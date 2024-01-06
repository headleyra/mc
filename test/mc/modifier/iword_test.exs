defmodule Mc.Modifier.IwordTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Iword

  @max_int 999_999_999_999_999_999_999_999_999_999_999_999
  @max_word "nine hundred and ninety nine decillion, nine hundred and ninety nine nonillion, nine hundred and ninety nine octillion, nine hundred and ninety nine septillion, nine hundred and ninety nine sextillion, nine hundred and ninety nine quintillion, nine hundred and ninety nine quadrillion, nine hundred and ninety nine trillion, nine hundred and ninety nine billion, nine hundred and ninety nine million, nine hundred and ninety nine thousand, nine hundred and ninety nine"

  describe "modify/3" do
    test "parses the `buffer` as an integer and converts it into its word equivalent" do
      assert Iword.modify("0", "n/a", %{}) == {:ok, "zero"}
      assert Iword.modify("1", "", %{}) == {:ok, "one"}
      assert Iword.modify("11", "", %{}) == {:ok, "eleven"}
      assert Iword.modify("1024", "", %{}) == {:ok, "one thousand and twenty four"}
      assert Iword.modify("#{@max_int}", "", %{}) == {:ok, @max_word}
    end

    test "works with negative integers" do
      assert Iword.modify("-1", "", %{}) == {:ok, "(minus) one"}
      assert Iword.modify("-3142", "", %{}) == {:ok, "(minus) three thousand, one hundred and forty two"}
      assert Iword.modify("-#{@max_int}", "", %{}) == {:ok, "(minus) #{@max_word}"}
    end

    test "works with integers embedded in whitespace" do
      assert Iword.modify("   -15", "", %{}) == {:ok, "(minus) fifteen"}
      assert Iword.modify("5\n\n", "", %{}) == {:ok, "five"}
      assert Iword.modify("\t 17 \n", "", %{}) == {:ok, "seventeen"}
    end

    test "errors when `buffer` is empty" do
      assert Iword.modify("", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.modify(" ", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.modify("\n\t", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
    end

    test "errors when `buffer` is not an integer" do
      assert Iword.modify("random string", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.modify("3.142", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
      assert Iword.modify("123 5", "", %{}) == {:error, "Mc.Modifier.Iword: no integer found"}
    end

    test "errors when the integer is too big (+/-)" do
      assert Iword.modify("#{@max_int+1}", "", %{}) == {:error, "Mc.Modifier.Iword: out of range"}
      assert Iword.modify("-#{@max_int+1}", "", %{}) == {:error, "Mc.Modifier.Iword: out of range"}
    end

    test "works with ok tuples" do
      assert Iword.modify({:ok, "7"}, "", %{}) == {:ok, "seven"}
    end

    test "allows error tuples to pass through" do
      assert Iword.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
