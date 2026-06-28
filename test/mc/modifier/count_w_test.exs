defmodule Mc.Modifier.CountWTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CountW

  describe "m/3" do
    test "returns the number of words in the `buffer`" do
      assert CountW.m("un deux trois", "n/a", %{}) == {:ok, "3"}
      assert CountW.m("\t\tfoobar\nbiz\n\n", "", %{}) == {:ok, "2"}
      assert CountW.m("not      for\nprofit", "", %{}) == {:ok, "3"}
      assert CountW.m(" \t  ", "", %{}) == {:ok, "0"}
      assert CountW.m("", "", %{}) == {:ok, "0"}
    end

    test "works with ok-tuples" do
      assert CountW.m({:ok, "why not best\nof seven?"}, "n/a", %{}) == {:ok, "5"}
    end

    test "allows error-tuples to pass through" do
      assert CountW.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
