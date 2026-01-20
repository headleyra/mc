defmodule Mc.AppTest do
  use ExUnit.Case, async: false
  alias Mc.App

  setup do
    map = %{
      "app1" => "casel",
      "app2" => "r a ::1",
      "app3" => "b 1: ::1, 2: ::2",
      "app4" => "b all: :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.s()}
  end

  describe "script/2" do
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "gets an app script given an app key and mappings", %{mappings: mappings} do
      assert App.script("app1", mappings) == {:ok, "casel"}
      assert App.script("app2", mappings) == {:ok, "r a ::1"}
      assert App.script("app3", mappings) == {:ok, "b 1: ::1, 2: ::2"}
    end

    test "errors when the app key doesn't exist", %{mappings: mappings} do
      assert App.script("no-exist", mappings) == {:error, :not_found, "no-exist"}
      assert App.script("", mappings) == {:error, :not_found, ""}
      assert App.script("  ", mappings) == {:error, :not_found, ""}
    end

    test "assigns arguments to placeholder replacements (::1, ::2, etc.)", %{mappings: mappings} do
      assert App.script("app2 one", mappings) == {:ok, "r a one"}
      assert App.script("app3 foo bar", mappings) == {:ok, "b 1: foo, 2: bar"}
    end

    test "assigns arguments to the 'all args' placeholder (::: => arg*)", %{mappings: mappings} do
      assert App.script("app4 yab dab do", mappings) == {:ok, "b all: yab dab do"}
    end

    test "errors when the app doesn't exist and arguments are passed", %{mappings: mappings} do
      assert App.script("no.exist arg1 arg2", mappings) == {:error, :not_found, "no.exist"}
      assert App.script("oops arg1", mappings) == {:error, :not_found, "oops"}
    end

    test "ignores extra arguments", %{mappings: mappings} do
      assert App.script("app2 bbb ignored", mappings) == {:ok, "r a bbb"}
    end

    test "doesn't assign placeholders with missing arguments", %{mappings: mappings} do
      assert App.script("app2", mappings) == {:ok, "r a ::1"}
    end

    test "ignores leading, internal and trailing whitespace", %{mappings: mappings} do
      assert App.script(" app1", mappings) == {:ok, "casel"}
      assert App.script("  app3 \t  ", mappings) == {:ok, "b 1: ::1, 2: ::2"}
      assert App.script("app3 \t one two", mappings) == {:ok, "b 1: one, 2: two"}
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
