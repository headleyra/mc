defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Run

  describe "modify/3" do
    test "treats `buffer` as a script and 'runs' it" do
      assert Run.modify("buffer FOO\ncasel", "", %Mc.Mappings{}) == {:ok, "foo"}
      assert Run.modify("buffer BAR\ncasel", "n/a", %Mc.Mappings{}) == {:ok, "bar"}
    end

    test "works with ok tuples" do
      assert Run.modify({:ok, "buffer Look\nreplace L B"}, "", %Mc.Mappings{}) == {:ok, "Book"}
    end

    test "allows error tuples to pass through" do
      assert Run.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
