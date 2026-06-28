defmodule Mc.Modifier.IwordTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Iword

  @max_int 999_999_999_999_999_999_999_999_999_999_999_999

  describe "m/3" do
    test "converts the integer in `buffer` to its word equivalent" do
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

    test "handles the maximum integer" do
      assert {:ok, _word} = Iword.m("#{@max_int}", "", %{})
    end

    test "errors with negative integers" do
      assert Iword.m("-1", "", %{}) == {:error, Mc.Modifier.Iword, :negative_integer, "-1", []}
      assert Iword.m("-31", "", %{}) == {:error, Mc.Modifier.Iword, :negative_integer, "-31", []}
    end

    test "errors when `buffer` is not an integer" do
      assert Iword.m("stuff", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "stuff", []}
      assert Iword.m("3.142", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "3.142", []}
      assert Iword.m("123 5", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "123 5", []}
      assert Iword.m("", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "", []}
      assert Iword.m("  ", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "  ", []}
      assert Iword.m("\n\t", "", %{}) == {:error, Mc.Modifier.Iword, :no_integer_found, "\n\t", []}
    end

    test "errors when the integer exceeds the maximum allowed" do
      assert Iword.m("#{@max_int + 1}", "", %{}) == {:error, Mc.Modifier.Iword, :maximum_integer_exceeded, nil, []}
    end

    test "works with ok-tuples" do
      assert Iword.m({:ok, "7"}, "", %{}) == {:ok, "seven"}
    end

    test "allows error-tuples to pass through" do
      assert Iword.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
