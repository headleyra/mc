defmodule Mc.Modifier.CaseUTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CaseU

  describe "modify/3" do
    test "uppercases the `buffer`" do
      assert CaseU.modify("Apples aNd Pears", "n/a", %{}) == {:ok, "APPLES AND PEARS"}
    end

    test "works with ok tuples" do
      assert CaseU.modify({:ok, "one, two\n3"}, "", %{}) == {:ok, "ONE, TWO\n3"}
    end

    test "allows error tuples to pass through" do
      assert CaseU.modify({:error, {:file, :not_found}}, "", %{}) == {:error, {:file, :not_found}}
    end
  end
end
