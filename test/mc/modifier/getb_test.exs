defmodule Mc.Modifier.GetbTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Getb

  describe "Mc.Modifier.Getb.modify/2" do
    test "returns the `buffer`" do
      assert Getb.modify("just the\nbuffer", "") == {:ok, "just the\nbuffer"}
      assert Getb.modify("", "") == {:ok, ""}
    end

    test "returns a help message" do
      assert Check.has_help?(Getb, :modify)
    end

    test "errors with unknown switches" do
      assert Getb.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Getb#modify: switch parse error"}
      assert Getb.modify("", "-u") == {:error, "Mc.Modifier.Getb#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Getb.modify({:ok, "best of 3"}, "") == {:ok, "best of 3"}
    end

    test "allows error tuples to pass through" do
      assert Getb.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
