defmodule Mc.Modifier.CaseLTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CaseL

  describe "m/3" do
    test "lowercases the `buffer`" do
      assert CaseL.m("FOO Bar", "", %{}) == {:ok, "foo bar"}
    end

    test "works with ok tuples" do
      assert CaseL.m({:ok, "BEST\nOF 3"}, "", %{}) == {:ok, "best\nof 3"}
    end

    test "allows error tuples to pass through" do
      assert CaseL.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
