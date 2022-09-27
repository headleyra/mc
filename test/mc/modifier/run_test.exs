defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Run

  setup do
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Run.modify/2" do
    test "treats `buffer` as a script and 'runs' it" do
      assert Run.modify("buffer FOO\nlcase", "") == {:ok, "foo"}
      assert Run.modify("buffer BAR\nlcase", "n/a") == {:ok, "bar"}
    end

    test "works with ok tuples" do
      assert Run.modify({:ok, "buffer Look\nreplace L B"}, "") == {:ok, "Book"}
    end

    test "allows error tuples to pass through" do
      assert Run.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
