defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.App

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{
      "app1" => "casel",
      "app2" => "replace a ::1",
      "app3" => "r a ::1",
      "app4" => "prepend ice-",
      "app5" => "buffer 1: ::1, 2: ::2",
      "app7" => "b all: :::"
    }})

    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "gets an app script using an app key and runs it against the `buffer`", %{mappings: mappings} do
      assert App.modify("DOT COM", "app1", mappings) == {:ok, "dot com"}
      assert App.modify("cube", "app4", mappings) == {:ok, "ice-cube"}
    end

    test "errors when the app doesn't exist", %{mappings: mappings} do
      assert App.modify("", "no-exist", mappings) == {:error, "Mc.Modifier.App: not found: no-exist"}
      assert App.modify("n/a", "no-app", mappings) == {:error, "Mc.Modifier.App: not found: no-app"}
      assert App.modify("", "", mappings) == {:error, "Mc.Modifier.App: not found: "}
    end

    test "assigns arguments to placeholders (::1, ::2, ...) before running the script", %{mappings: mappings} do
      assert App.modify("a b", "app3 arg1 arg2", mappings) == {:ok, "arg1 b"}
      assert App.modify("a:a", "app3 alpha", mappings) == {:ok, "alpha:alpha"}
      assert App.modify("FOOBAR", "app1 no.replacements", mappings) == {:ok, "foobar"}
    end

    test "errors when the app doesn't exist and arguments are passed", %{mappings: mappings} do
      assert App.modify("n/a", "oops arg1", mappings) == {:error, "Mc.Modifier.App: not found: oops"}
      assert App.modify("", "no-exist a1 a2", mappings) == {:error, "Mc.Modifier.App: not found: no-exist"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)", %{mappings: mappings} do
      assert App.modify("", "app7 yab dab do", mappings) == {:ok, "all: yab dab do"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert App.modify({:ok, "BIG"}, "app1", mappings) == {:ok, "big"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert App.modify({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
