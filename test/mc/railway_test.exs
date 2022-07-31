defmodule Mc.RailwayTest do
  use ExUnit.Case, async: true

  defmodule Mymod do
    use Mc.Railway, [:down, :up]

    def down(buffer, _args), do: {:ok, String.downcase(buffer)}
    def up(buffer, _args), do: {:ok, String.upcase(buffer)}
  end

  describe "Mc.Railway" do
    test "creates a function that, given an error tuple (as `buffer`), returns it unchanged" do
      assert Mymod.down({:error, "boom"}, "n/a") == {:error, "boom"}
      assert Mymod.up({:error, "oops"}, "dont matter") == {:error, "oops"}
    end

    test "creates a function that, given an ok tuple (as `buffer`), delegates to the string equivalent" do
      assert Mymod.down({:ok, "BoSh"}, "") == {:ok, "bosh"}
      assert Mymod.up({:ok, "dar\nordar"}, "") == {:ok, "DAR\nORDAR"}
    end

    test "creates a 'name' function that returns the canonical modifier name" do
      assert Mymod.name(:down) == "Mc.RailwayTest.Mymod#down"
      assert Mymod.name(:up) == "Mc.RailwayTest.Mymod#up"
    end

    test "creates a 'oops' function that returns an error tuple" do
      assert Mymod.oops(:down, "kaboom") == {:error, "Mc.RailwayTest.Mymod#down: kaboom"}
    end

    test "creates a 'usage' function that returns an error tuple" do
      assert Mymod.usage(:up, "<usage deets>") == {:error, "usage: Mc.RailwayTest.Mymod#up <usage deets>"}
      assert Mymod.usage(:down, "<usage deets>") == {:error, "usage: Mc.RailwayTest.Mymod#down <usage deets>"}
    end

    test "creates a 'help' function that returns help text" do
      assert Mymod.help(:up, "This is help\ntext") == {:ok, "Mc.RailwayTest.Mymod#up\n\nThis is help\ntext"}
    end
  end
end
