defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Run

  setup do
    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "treats `buffer` as a script and 'runs' it", %{mappings: mappings} do
      assert Run.modify("buffer FOO\ncasel", "", mappings) == {:ok, "foo"}
      assert Run.modify("buffer BAR\ncasel", "n/a", mappings) == {:ok, "bar"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Run.modify({:ok, "buffer Look\nreplace L B"}, "", mappings) == {:ok, "Book"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Run.modify({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
