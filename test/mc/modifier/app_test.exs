defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.App

  defmodule Mappings do
    defstruct [
      buffer: Mc.Modifier.Buffer,
      get: Mc.Modifier.Get,
      lcase: Mc.Modifier.Lcase,
      replace: Mc.Modifier.Replace
    ]
  end

  setup do
    start_supervised({KvMemory, map: %{
      "app1" => "script1",
      "app3" => "script3\nscript5",
      "app5" => "script3",
      "app7" => "script7",
      "script1" => "lcase",
      "script3" => "replace a ::1",
      "script5" => "replace b ::2",
      "script7" => "buffer 1 => ::1, 2 => ::2, all => :::"
    }})

    :ok
  end

  describe "modify/3" do
    test "builds an 'app script' given an 'app key' and runs it against the `buffer`" do
      assert App.modify("DOT COM", "app1", %Mappings{}) == {:ok, "dot com"}
      assert App.modify("stuff", "", %Mappings{}) == {:ok, "stuff"}
      assert App.modify("", "", %Mappings{}) == {:ok, ""}
    end

    test "replaces placeholders (::1 => arg1, ::2 => arg2, ...) before running the script" do
      assert App.modify("a b c", "app3 arg1 arg2", %Mappings{}) == {:ok, "arg1 arg2 c"}
      assert App.modify("a:a", "app5 alpha", %Mappings{}) == {:ok, "alpha:alpha"}
      assert App.modify("", "app7 un deux trois", %Mappings{}) == {:ok, "1 => un, 2 => deux, all => un deux trois"}
      assert App.modify("FOOBAR", "app1 no.replacements.for.this.app", %Mappings{}) == {:ok, "foobar"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)" do
      assert App.modify("", "app7 yab dab do", %Mappings{}) == {:ok, "1 => yab, 2 => dab, all => yab dab do"}
    end

    test "works with ok tuples" do
      assert App.modify({:ok, "BIG"}, "app1", %Mappings{}) == {:ok, "big"}
    end

    test "allows error tuples to pass through" do
      assert App.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
