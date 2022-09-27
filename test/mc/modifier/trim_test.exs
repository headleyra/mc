defmodule Mc.Modifier.TrimTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Trim

  describe "Mc.Modifier.Trim.modify/2" do
    test "trims whitespace on the `buffer`" do
      assert Trim.modify("\t\n\n  relevant stuff \n\n\n\n \t ", "n/a") == {:ok, "relevant stuff"}
      assert Trim.modify("already trim", "") == {:ok, "already trim"}
    end

    test "works with ok tuples" do
      assert Trim.modify({:ok, "bat and ball \t\n"}, "n/a") == {:ok, "bat and ball"}
    end

    test "allows error tuples to pass through" do
      assert Trim.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
