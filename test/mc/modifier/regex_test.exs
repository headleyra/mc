defmodule Mc.Modifier.RegexTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Regex

  setup do
    %{
      text: """
      I wake up in the morning
      and make a cup of coffee.

      Ground coffee, I prefer.

      By my reckoning, 17 times 3
      equals 51
      """
    }
  end

  describe "modify/3" do
    test "runs the regular expression on the `buffer` and returns anything that matches", %{text: text} do
      assert Regex.modify(text, "17.*3", %{}) == {:ok, "17 times 3"}
    end

    test "matches across newlines", %{text: text} do
      assert Regex.modify(text, "morning.*make", %{}) == {:ok, "morning\nand make"}
    end

    test "handles repeating characters", %{text: text} do
      assert Regex.modify(text, ~S"\D{5}\d+\D{5}", %{}) == {:ok, "ing, 17 time"}
      assert Regex.modify(text, ".{0,11}51.{0,10}", %{}) == {:ok, "s 3\nequals 51\n"}
    end

    test "handles 'greedy' and 'non-greedy'", %{text: text} do
      assert Regex.modify(text, "cup.*coffee", %{}) == {:ok, "cup of coffee.\n\nGround coffee"}
      assert Regex.modify(text, "cup.*?coffee", %{}) == {:ok, "cup of coffee"}
    end

    test "handles 'captures'", %{text: text} do
      assert Regex.modify(text, ~S"By.+(\d\d)", %{}) == {:ok, "51"}
      assert Regex.modify(text, ~S"By.*(1\d).*?(\d)", %{}) == {:ok, "17\n3"}
    end

    test "returns empty string when there is no match" do
      assert Regex.modify("foo", "bar", %{}) == {:ok, ""}
    end

    test "errors when the regex is bad" do
      assert Regex.modify("one\ntwo", "?", %{}) == {:error, "Mc.Modifier.Regex: bad regex"}
    end

    test "works with ok tuples" do
      assert Regex.modify({:ok, "some buffer text"}, "me.*uf", %{}) == {:ok, "me buf"}
    end

    test "allows error tuples to pass through" do
      assert Regex.modify({:error, "reason"}, "gets ignored", %{}) == {:error, "reason"}
    end
  end
end
