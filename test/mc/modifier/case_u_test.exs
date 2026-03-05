defmodule Mc.Modifier.CaseUTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CaseU

  describe "m/3" do
    test "uppercases the `buffer`" do
      assert CaseU.m("Apples aNd Pears", "n/a", %{}) == {:ok, "APPLES AND PEARS"}
    end

    test "works with ok tuples" do
      assert CaseU.m({:ok, "one, two\n3"}, "", %{}) == {:ok, "ONE, TWO\n3"}
    end

    test "allows error tuples to pass through" do
      assert CaseU.m({:error, {:file, :not_found}}, "", %{}) == {:error, {:file, :not_found}}
    end
  end
end
