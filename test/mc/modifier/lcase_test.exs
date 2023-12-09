defmodule Mc.Modifier.LcaseTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Lcase

  describe "modify/3" do
    test "lowercases the `buffer`" do
      assert Lcase.modify("FOO Bar", "", %{}) == {:ok, "foo bar"}
    end

    test "works with ok tuples" do
      assert Lcase.modify({:ok, "BEST\nOF 3"}, "", %{}) == {:ok, "best\nof 3"}
    end

    test "allows error tuples to pass through" do
      assert Lcase.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
