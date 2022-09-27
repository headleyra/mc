defmodule Mc.Modifier.UcaseTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Ucase

  describe "Mc.Modifier.Ucase.modify/2" do
    test "uppercases the `buffer`" do
      assert Ucase.modify("Apples aNd Pears", "n/a") == {:ok, "APPLES AND PEARS"}
    end

    test "works with ok tuples" do
      assert Ucase.modify({:ok, "one, two\n3"}, "") == {:ok, "ONE, TWO\n3"}
    end

    test "allows error tuples to pass through" do
      assert Ucase.modify({:error, {:file, :not_found}}, "") == {:error, {:file, :not_found}}
    end
  end
end
