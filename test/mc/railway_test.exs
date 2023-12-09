defmodule Mc.RailwayTest do
  use ExUnit.Case, async: true

  defmodule Modi do
    use Mc.Railway, [:small, :big]

    def small(buffer, _args, _mappings), do: {:ok, String.downcase(buffer)}
    def big(buffer, _args, _mappings), do: {:ok, String.upcase(buffer)}
  end

  describe "Mc.Railway" do
    test "creates a function that, given an error tuple (as `buffer`), returns it unchanged" do
      assert Modi.small({:error, "boom"}, "n/a", %{}) == {:error, "boom"}
      assert Modi.big({:error, "oops"}, "", %{}) == {:error, "oops"}
    end

    test "creates a function that, given an ok tuple (as `buffer`), delegates to the string equivalent" do
      assert Modi.small({:ok, "BoSh"}, "", %{}) == {:ok, "bosh"}
      assert Modi.big({:ok, "dar\nordar"}, "", %{}) == {:ok, "DAR\nORDAR"}
    end

    test "creates a 'name' function that returns the canonical modifier name" do
      assert Modi.name(:small) == "Mc.RailwayTest.Modi#small"
      assert Modi.name(:big) == "Mc.RailwayTest.Modi#big"
    end

    test "creates a 'oops' function that generates an error for a known modifier" do
      assert Modi.oops(:small, "kaboom") == {:error, "Mc.RailwayTest.Modi#small: kaboom"}
      assert Modi.oops(:big, "splash") == {:error, "Mc.RailwayTest.Modi#big: splash"}
    end
  end
end
