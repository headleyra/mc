defmodule Mc.Modifier.LcaseTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Lcase

  describe "Mc.Modifier.Lcase.modify/2" do
    test "lowercases the `buffer`" do
      assert Lcase.modify("FOO Bar", "") == {:ok, "foo bar"}
    end

    test "returns a help message" do
      assert Check.has_help?(Lcase, :modify)
    end

    test "errors with unknown switches" do
      assert Lcase.modify("", "--unknown") == {:error, "Mc.Modifier.Lcase#modify: switch parse error"}
      assert Lcase.modify("", "-u") == {:error, "Mc.Modifier.Lcase#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Lcase.modify({:ok, "BEST\nOF 3"}, "") == {:ok, "best\nof 3"}
    end

    test "allows error tuples to pass through" do
      assert Lcase.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
