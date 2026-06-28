defmodule Mc.AppTest do
  use ExUnit.Case, async: false
  alias Mc.App

  setup do
    map = %{
      "app1" => "casel",
      "app2" => "replace a ::1",
      "app3" => "buffer 1: ::1, 2: ::2",
      "app4" => "buffer all: :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "script/2" do
    test "gets an 'app script' given a key and mappings", %{mappings: mappings} do
      assert App.script("app1", mappings) == {:ok, "casel"}
      assert App.script("app2", mappings) == {:ok, "replace a ::1"}
      assert App.script("app3", mappings) == {:ok, "buffer 1: ::1, 2: ::2"}
    end

    test "assigns arguments to placeholder replacements (::1, ::2, etc.)", %{mappings: mappings} do
      assert App.script("app2 one", mappings) == {:ok, "replace a one"}
      assert App.script("app3 foo bar", mappings) == {:ok, "buffer 1: foo, 2: bar"}
    end

    test "assigns arguments to the 'all args' placeholder (::: => arg*)", %{mappings: mappings} do
      assert App.script("app4 yab dab do", mappings) == {:ok, "buffer all: yab dab do"}
    end

    test "ignores extra, redundant arguments", %{mappings: mappings} do
      assert App.script("app2 bbb ignored", mappings) == {:ok, "replace a bbb"}
    end

    test "doesn't assign placeholders with missing arguments", %{mappings: mappings} do
      assert App.script("app2", mappings) == {:ok, "replace a ::1"}
    end

    test "ignores leading, internal and trailing whitespace", %{mappings: mappings} do
      assert App.script(" app1", mappings) == {:ok, "casel"}
      assert App.script("  app3 \t  ", mappings) == {:ok, "buffer 1: ::1, 2: ::2"}
      assert App.script("app3 \t one two", mappings) == {:ok, "buffer 1: one, 2: two"}
    end

    test "errors when the app key doesn't exist", %{mappings: mappings} do
      assert App.script("no-exist", mappings) == {:error, :not_found, "no-exist"}
      assert App.script("not_here", mappings) == {:error, :not_found, "not_here"}
    end

    test "errors when the app key is missing", %{mappings: mappings} do
      assert App.script("", mappings) == {:error, :missing_app_key, nil}
      assert App.script("  ", mappings) == {:error, :missing_app_key, nil}
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
