defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.App

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{
      "app1" => "script1",
      "app2" => "script2   \t script3",
      "app4" => "script2",
      "app5" => "noexist script1",
      "script1" => "lcase",
      "script2" => "b brexit ex why\nreplace ex ::1",
      "script3" => "r why ::2"
    }})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.App.modify/2" do
    test "builds an 'app' script using 2 levels of KV indirection" do
      assert App.modify("n/a", "app1") == {:ok, "lcase"}
      assert App.modify("", "app2") == {:ok, "b brexit ex why\nreplace ex ::1\nr why ::2"}
    end

    test "processes inline replacements" do
      assert App.modify("", "app1 there.are.no.replacements.for.this.app") == {:ok, "lcase"}
      assert App.modify("", "app4 exit") == {:ok, "b brexit ex why\nreplace ex exit"}
      assert App.modify("", "app2 un deux") == {:ok, "b brexit ex why\nreplace ex un\nr why deux"}
    end

    test "returns emtpy string when no app name is given" do
      assert App.modify("", "") == {:ok, ""}
    end

    test "ignores 'sub-app' keys that don't exist" do
      assert App.modify("", "app5") == {:ok, "lcase"}
    end

    test "works with ok tuples" do
      assert App.modify({:ok, "n/a"}, "app2 un deux") == {:ok, "b brexit ex why\nreplace ex un\nr why deux"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert App.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.App.modifyr/2" do
    test "builds an 'app' script using 2 levels of KV indirection and 'runs' it against the `buffer`" do
      assert App.modifyr("DOT COM", "app1") == {:ok, "dot com"}
      assert App.modifyr("", "app2 : ish") == {:ok, "br:it : ish"}
      assert App.modifyr("", "app4 *") == {:ok, "br*it * why"}
      assert App.modifyr("FOOBAR", "app1 there.are.no.replacements.for.this.app") == {:ok, "foobar"}
    end

    test "returns emtpy string when no app name is given" do
      assert App.modifyr("", "") == {:ok, ""}
    end

    test "ignores 'sub-app' keys that don't exist" do
      assert App.modifyr("ApP\nExpansioN", "app5") == {:ok, "app\nexpansion"}
    end

    test "works with ok tuples" do
      assert App.modifyr({:ok, "n/a"}, "app2 x backstop") == {:ok, "brxit x backstop"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert App.modifyr({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.App.build/1" do
    test "builds an 'app' script" do
      assert App.build("app1") == "lcase"
      assert App.build("app2") == "b brexit ex why\nreplace ex ::1\nr why ::2"
      assert App.build("app4") == "b brexit ex why\nreplace ex ::1"
      assert App.build("app5") == "lcase"
    end
  end
end
