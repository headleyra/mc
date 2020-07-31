defmodule Mc.Modifier.TrimTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Trim

  describe "Mc.Modifier.Trim.modify/2" do
    test "'trims' white space on the `buffer`" do
      assert Trim.modify("\t\n\n  relevant stuff \n\n\n\n \t ", "n/a") == {:ok, "relevant stuff"}
      assert Trim.modify("already trim", "") == {:ok, "already trim"}
    end

    test "works with ok tuples" do
      assert Trim.modify({:ok, "bat and ball \t\n"}, "n/a") == {:ok, "bat and ball"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Trim.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Trim.modifyn/2" do
    test "'trims' newlines on the `buffer`" do
      assert Trim.modifyn("\n\n relevant stuff \n", "n/a") == {:ok, " relevant stuff "}
      assert Trim.modifyn("\t \n\n relevant stuff \n ", "n/a") == {:ok, "\t \n\n relevant stuff \n "}
      assert Trim.modifyn("already trim", "") == {:ok, "already trim"}
    end

    test "works with ok tuples" do
      assert Trim.modifyn({:ok, "bat and ball \t\n"}, "n/a") == {:ok, "bat and ball \t"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Trim.modifyn({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
