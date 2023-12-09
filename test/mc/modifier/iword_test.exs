defmodule Mc.Modifier.IwordTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Iword

  describe "modify/3" do
    test "parses the `buffer` as an integer and converts it into its word equivalent" do
      assert Iword.modify("0", "n/a", %{}) == {:ok, "zero"}
      assert Iword.modify("1", "", %{}) == {:ok, "one"}
      assert Iword.modify("11", "", %{}) == {:ok, "eleven"}
      assert Iword.modify("1024", "", %{}) == {:ok, "one thousand and twenty four"}
    end

    test "works with negative integers" do
      assert Iword.modify("-1", "", %{}) == {:ok, "(minus) one"}
      assert Iword.modify("-3142", "", %{}) == {:ok, "(minus) three thousand, one hundred and forty two"}
    end

    test "works with integers embedded in whitespace" do
      assert Iword.modify("   -15", "", %{}) == {:ok, "(minus) fifteen"}
      assert Iword.modify("5\n\n", "", %{}) == {:ok, "five"}
      assert Iword.modify("\t 17 \n", "", %{}) == {:ok, "seventeen"}
    end

    test "errors when `buffer` is empty" do
      assert Iword.modify("", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
      assert Iword.modify(" ", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
      assert Iword.modify("\n\t", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
    end

    test "errors when `buffer` is not an integer" do
      assert Iword.modify("random string", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
      assert Iword.modify("3.142", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
      assert Iword.modify("123 5", "", %{}) == {:error, "Mc.Modifier.Iword#modify: no integer found"}
    end

    test "works with ok tuples" do
      assert Iword.modify({:ok, "7"}, "", %{}) == {:ok, "seven"}
    end

    test "allows error tuples to pass through" do
      assert Iword.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
