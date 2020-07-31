defmodule Mc.RailwayTest do
  use ExUnit.Case, async: true

  describe "Mc.Railway" do
    defmodule TestMod do
      use Mc.Railway, [:down, :up]

      def down(buffer, _args) do
        {:ok, String.downcase(buffer)}
      end

      def up(buffer, _args) do
        {:ok, String.upcase(buffer)}
      end
    end

    test "creates a function to handle error tuples which should 'pass-through' unchanged" do
      assert TestMod.down({:error, "boom"}, "n/a") == {:error, "boom"}
      assert TestMod.up({:error, "oops"}, "dont matter") == {:error, "oops"}
    end

    test "creates a function to handle ok tuples" do
      assert TestMod.down({:ok, "BoSh"}, "") == {:ok, "bosh"}
      assert TestMod.up({:ok, "dar\nordar"}, "") == {:ok, "DAR\nORDAR"}
    end

    test "handles the 'standard' case" do
      assert TestMod.down("BIG\tLETTERS\n", "ignored") == {:ok, "big\tletters\n"}
      assert TestMod.up("Orange Juice", "ignored") == {:ok, "ORANGE JUICE"}
    end
  end
end
