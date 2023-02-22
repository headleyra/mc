defmodule Mc.AppTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Get
  alias Mc.App

  setup do
    start_supervised({KvMemory, map: %{
      "app1" => "script1",
      "app3" => "script3\nscript5",
      "app5" => "script3",
      "app7" => "script7",
      "script1" => "lcase",
      "script3" => "r a ::1",
      "script5" => "r b ::2",
      "script7" => "b 1 => ::1, 2 => ::2, all => :::"
    }, name: :cash})

    start_supervised({Get, kv_pid: :cash})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "script/1" do
    test "builds an 'app script' given an 'app key'" do
      assert App.script("app1") == {:ok, "lcase"}
      assert App.script("app3") == {:ok, "r a ::1\nr b ::2"}
      assert App.script("app5") == {:ok, "r a ::1"}
      assert App.script("app7") == {:ok, "b 1 => ::1, 2 => ::2, all => :::"}
      assert App.script("") == {:ok, ""}
    end

    test "builds an 'app script' given an 'app key' and placeholder replacements" do
      assert App.script("app3 one two") == {:ok, "r a one\nr b two"}
      assert App.script("app5 bbb ignored") == {:ok, "r a bbb"}
      assert App.script("app7 foo bar roo") == {:ok, "b 1 => foo, 2 => bar, all => foo bar roo"}
    end

    test "ignores leading, internal and trailing whitespace" do
      assert App.script("   app1") == {:ok, "lcase"}
      assert App.script("   app3 \t  ") == {:ok, "r a ::1\nr b ::2"}
      assert App.script("   app3  \t   one \t   two   ") == {:ok, "r a one\nr b two"}
    end
  end

  describe "expand/2" do
    test "expands `script` using the given placeholder replacements (::1 => repl1, ::2 => repl2, ...)" do
      assert App.expand("1: ::1", ["un"]) == {:ok, "1: un"}
      assert App.expand("1: ::1, 2: ::2", ["un", "deux"]) == {:ok, "1: un, 2: deux"}
      assert App.expand("::1\n::2", []) == {:ok, "::1\n::2"}
      assert App.expand("::1\n::2", ["only one"]) == {:ok, "only one\n::2"}
      assert App.expand("no placeholders", ["one", "two"]) == {:ok, "no placeholders"}
    end

    test "replaces the 'all args' placeholder: ':::' => all args" do
      assert App.expand("all: :::", ["p1", "p2"]) == {:ok, "all: p1 p2"}
      assert App.expand(":::", []) == {:ok, ":::"}
      assert App.expand("*:::*", ["just one"]) == {:ok, "*just one*"}
    end
  end
end
