defmodule Mc.Modifier.TrimTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Trim

  describe "Mc.Modifier.Trim.modify/2" do
    test "trims white space on the `buffer`" do
      assert Trim.modify("\t\n\n  relevant stuff \n\n\n\n \t ", "n/a") == {:ok, "relevant stuff"}
      assert Trim.modify("already trim", "") == {:ok, "already trim"}
    end

    test "returns a help message" do
      assert Check.has_help?(Trim, :modify)
    end

    test "errors with unknown switches" do
      assert Trim.modify("", "--unknown") == {:error, "Mc.Modifier.Trim#modify: switch parse error"}
      assert Trim.modify("", "-u") == {:error, "Mc.Modifier.Trim#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Trim.modify({:ok, "bat and ball \t\n"}, "n/a") == {:ok, "bat and ball"}
    end

    test "allows error tuples to pass through" do
      assert Trim.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
