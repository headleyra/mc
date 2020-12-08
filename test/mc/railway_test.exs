defmodule Mc.RailwayTest do
  use ExUnit.Case, async: true

  defmodule TestModifier do
    use Mc.Railway, [:down, :up]

    def down(buffer, _args), do: {:ok, String.downcase(buffer)}
    def up(buffer, _args), do: {:ok, String.upcase(buffer)}
  end

  # setup do
  #   mappings = %{
  #     small: {TestModifier, :down},
  #     big: {TestModifier, :up}
  #   }

  #   start_supervised({Mc, mappings: mappings})
  #   :ok
  # end

  describe "Mc.Railway" do
    test "creates functions that, given an error tuple (as `buffer`), return it unchanged" do
      assert TestModifier.down({:error, "boom"}, "n/a") == {:error, "boom"}
      assert TestModifier.up({:error, "oops"}, "dont matter") == {:error, "oops"}
    end

    test "creates functions that, given an ok tuple (as `buffer`), delegate to their string equivalents" do
      assert TestModifier.down({:ok, "BoSh"}, "") == {:ok, "bosh"}
      assert TestModifier.up({:ok, "dar\nordar"}, "") == {:ok, "DAR\nORDAR"}
    end

    @tag :skip
    test "creates an error tuple builder function" do
      assert TestModifier.oops("the error message", :down) == {:error, "small: the error message"}
      assert TestModifier.oops("oops!", :up) == {:error, "big: oops!"}
    end
  end
end
