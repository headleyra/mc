defmodule Mc.Modifier.IwordTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Iword

  @max_int 999_999_999_999_999_999_999_999_999_999_999_999

  describe "m/3" do
    test "converts `buffer` into its word equivalent" do
      assert Iword.m("0", "n/a", %{}) == {:ok, "zero"}
      assert Iword.m("1", "", %{}) == {:ok, "one"}
      assert Iword.m("11", "", %{}) == {:ok, "eleven"}
      assert Iword.m("1024", "", %{}) == {:ok, "one thousand and twenty four"}
    end

    test "works with integers embedded in whitespace" do
      assert Iword.m("   15", "", %{}) == {:ok, "fifteen"}
      assert Iword.m("5\n\n", "", %{}) == {:ok, "five"}
      assert Iword.m("\t 17 \n", "", %{}) == {:ok, "seventeen"}
    end

    test "errors with negative integers" do
      assert Iword.m("-1", "", %{}) == {:error, "Mc.Modifier.Iword: negative integer"}
      assert Iword.m("-31", "", %{}) == {:error, "Mc.Modifier.Iword: negative integer"}
    end

    test "errors when `buffer` is empty" do
      assert Iword.m("", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.m(" ", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.m("\n\t", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
    end

    test "errors when `buffer` is not an integer" do
      assert Iword.m("random string", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.m("3.142", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.m("123 5", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
    end

    test "errors when the integer is too big (+/-)" do
      assert Iword.m("#{@max_int + 1}", "", %{}) == {:error, "Mc.Modifier.Iword: out of range"}
    end

    test "works with ok tuples" do
      assert Iword.m({:ok, "7"}, "", %{}) == {:ok, "seven"}
    end

    test "allows error tuples to pass through" do
      assert Iword.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
