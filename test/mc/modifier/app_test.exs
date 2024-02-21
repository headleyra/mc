defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.App

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{
      "app1" => "casel",
      "app2" => "replace a ::1",
      "app3" => "r a ::1",
      "app4" => "prepend ice%20",
      "app5" => "buffer 1 => ::1, 2 => ::2, all => :::"
    }})

    :ok
  end

  describe "modify/3" do
    test "builds an 'app' script given an 'app' key and runs it against the `buffer`" do
      assert App.modify("DOT COM", "app1", %Mc.Mappings{}) == {:ok, "dot com"}
      assert App.modify("cube", "app4", %Mc.Mappings{}) == {:ok, "ice cube"}
    end

    test "errors when the app doesn't exist" do
      assert App.modify("", "no-exist-app", %Mc.Mappings{}) == {:error, "Mc.Modifier.App: app not found"}
      assert App.modify("n/a", "no-exist-app", %Mc.Mappings{}) == {:error, "Mc.Modifier.App: app not found"}
    end

    test "assigns arguments to placeholders (::1, ::2, etc.) before running the script" do
      assert App.modify("a b", "app3 arg1 arg2", %Mc.Mappings{}) == {:ok, "arg1 b"}
      assert App.modify("a:a", "app3 alpha", %Mc.Mappings{}) == {:ok, "alpha:alpha"}

      assert App.modify("", "app5 un deux trois", %Mc.Mappings{}) ==
        {:ok, "1 => un, 2 => deux, all => un deux trois"}

      assert App.modify("FOOBAR", "app1 no.replacements.for.this.app", %Mc.Mappings{}) == {:ok, "foobar"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)" do
      assert App.modify("", "app5 yab dab do", %Mc.Mappings{}) == {:ok, "1 => yab, 2 => dab, all => yab dab do"}
    end

    test "works with ok tuples" do
      assert App.modify({:ok, "BIG"}, "app1", %Mc.Mappings{}) == {:ok, "big"}
    end

    test "allows error tuples to pass through" do
      assert App.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
