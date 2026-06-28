defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.App

  setup do
    map = %{
      "app1" => "casel",
      "app2" => "replace x ::1",
      "app3" => "prepend ice-",
      "app4" => "buffer all: :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "gets an 'app script' using an 'app key' (`args`) and then runs it against `buffer`", %{mappings: mappings} do
      assert App.m("DOT COM", "app1", mappings) == {:ok, "dot com"}
      assert App.m("cube", "app3", mappings) == {:ok, "ice-cube"}
    end

    test "assigns arguments to placeholders (::1, ::2, ...) before running the script", %{mappings: mappings} do
      assert App.m("x b", "app2 arg1 arg2", mappings) == {:ok, "arg1 b"}
      assert App.m("x:x", "app2 alpha", mappings) == {:ok, "alpha:alpha"}
      assert App.m("FOOBAR", "app1 no.placeholders.in.the.script", mappings) == {:ok, "foobar"}
    end

    test "replaces the 'all args' placeholder (:::)", %{mappings: mappings} do
      assert App.m("", "app4 yaba daba do", mappings) == {:ok, "all: yaba daba do"}
    end

    test "errors when the app doesn't exist", %{mappings: mappings} do
      assert App.m("", "no-exist", mappings) == {:error, Mc.Modifier.App, :app_key_not_found, "no-exist", []}
      assert App.m("n/a", "no-app", mappings) == {:error, Mc.Modifier.App, :app_key_not_found, "no-app", []}
      assert App.m("n/a", "oops arg1", mappings) == {:error, Mc.Modifier.App, :app_key_not_found, "oops", []}
    end

    test "errors when the app key is missing", %{mappings: mappings} do
      assert App.m("n/a", "", mappings) == {:error, Mc.Modifier.App, :missing_app_key, nil, []}
      assert App.m("", "  ", mappings) == {:error, Mc.Modifier.App, :missing_app_key, nil, []}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert App.m({:ok, "BIG"}, "app1", mappings) == {:ok, "big"}
    end

    test "allows error-tuples to pass through" do
      assert App.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
