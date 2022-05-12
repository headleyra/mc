defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.App

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{
      "app1" => "script1",
      "app3" => "script2   \t script3",
      "app5" => "script2",
      "app7" => "noexist script1",
      "app11" => "script4",
      "script1" => "lcase",
      "script2" => "b brexit ex why\nreplace ex ::1",
      "script3" => "r why ::2",
      "script4" => "b 1: ::1, 2: ::2, all: :::"
    }})
    :ok
  end

  describe "Mc.Modifier.App.modify/2" do
    test "builds an 'app' script using 2 levels of KV indirection" do
      assert App.modify("n/a", "app1") == {:ok, "lcase"}
      assert App.modify("", "app3") == {:ok, "b brexit ex why\nreplace ex ::1\nr why ::2"}
    end

    test "processes inline replacements" do
      assert App.modify("", "app1 there.are.no.replacements.for.this.app") == {:ok, "lcase"}
      assert App.modify("", "app5 exit") == {:ok, "b brexit ex why\nreplace ex exit"}
      assert App.modify("", "app3 un deux") == {:ok, "b brexit ex why\nreplace ex un\nr why deux"}
      assert App.modify("", "app11 uno dos") == {:ok, "b 1: uno, 2: dos, all: uno dos"}
    end

    test "returns emtpy string when no app name is given" do
      assert App.modify("", "") == {:ok, ""}
    end

    test "ignores 'sub-app' keys that don't exist" do
      assert App.modify("", "app7") == {:ok, "lcase"}
    end

    test "works with ok tuples" do
      assert App.modify({:ok, "n/a"}, "app3 un deux") == {:ok, "b brexit ex why\nreplace ex un\nr why deux"}
    end

    test "allows error tuples to pass-through" do
      assert App.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.App.modifyr/2" do
    test "builds an 'app' script using 2 levels of KV indirection and 'runs' it against the `buffer`" do
      assert App.modifyr("DOT COM", "app1") == {:ok, "dot com"}
      assert App.modifyr("", "app3 : ish") == {:ok, "br:it : ish"}
      assert App.modifyr("", "app5 *") == {:ok, "br*it * why"}
      assert App.modifyr("FOOBAR", "app1 there.are.no.replacements.for.this.app") == {:ok, "foobar"}
      assert App.modifyr("n/a", "app11 yabba dabba do") == {:ok, "1: yabba, 2: dabba, all: yabba dabba do"}
    end

    test "returns emtpy string when no app name is given" do
      assert App.modifyr("", "") == {:ok, ""}
    end

    test "ignores 'sub-app' keys that don't exist" do
      assert App.modifyr("ApP\nExpansioN", "app7") == {:ok, "app\nexpansion"}
    end

    test "works with ok tuples" do
      assert App.modifyr({:ok, "n/a"}, "app3 x backstop") == {:ok, "brxit x backstop"}
    end

    test "allows error tuples to pass-through" do
      assert App.modifyr({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.App.build/1" do
    test "builds an 'app' script" do
      assert App.build("app1") == "lcase"
      assert App.build("app3") == "b brexit ex why\nreplace ex ::1\nr why ::2"
      assert App.build("app5") == "b brexit ex why\nreplace ex ::1"
      assert App.build("app7") == "lcase"
    end
  end

  describe "Mc.Modifier.App.script_from/2" do
    test "returns a script with with replacements" do
      assert App.script_from("b ::1", "foo") == {:ok, "b foo"}
      assert App.script_from("r ::2 ::1", "foo bar") == {:ok, "r bar foo"}
      assert App.script_from("b 1: ::1, 2: ::2, all: :::", "uno dos") == {:ok, "b 1: uno, 2: dos, all: uno dos"}
      assert App.script_from("b :::", "all   4 one") == {:ok, "b all   4 one"}
    end
  end
end
