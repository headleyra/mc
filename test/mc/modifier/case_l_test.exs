defmodule Mc.Modifier.CaseLTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CaseL

  describe "modify/3" do
    test "lowercases the `buffer`" do
      assert CaseL.modify("FOO Bar", "", %{}) == {:ok, "foo bar"}
    end

    test "works with ok tuples" do
      assert CaseL.modify({:ok, "BEST\nOF 3"}, "", %{}) == {:ok, "best\nof 3"}
    end

    test "allows error tuples to pass through" do
      assert CaseL.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
