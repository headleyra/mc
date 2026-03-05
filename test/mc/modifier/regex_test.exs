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

  describe "m/3" do
    test "runs the regular expression on the `buffer` and returns anything that matches", %{text: text} do
      assert Regex.m(text, "17.*3", %{}) == {:ok, "17 times 3"}
    end

    test "matches across newlines", %{text: text} do
      assert Regex.m(text, "morning.*make", %{}) == {:ok, "morning\nand make"}
    end

    test "handles repeating characters", %{text: text} do
      assert Regex.m(text, ~S"\D{5}\d+\D{5}", %{}) == {:ok, "ing, 17 time"}
      assert Regex.m(text, ".{0,11}51.{0,10}", %{}) == {:ok, "s 3\nequals 51\n"}
    end

    test "handles 'greedy' and 'non-greedy'", %{text: text} do
      assert Regex.m(text, "cup.*coffee", %{}) == {:ok, "cup of coffee.\n\nGround coffee"}
      assert Regex.m(text, "cup.*?coffee", %{}) == {:ok, "cup of coffee"}
    end

    test "handles caret and dollar", %{text: text} do
      assert Regex.m(text, "^(Ground.*?)$", %{}) == {:ok, "Ground coffee, I prefer."}
      assert Regex.m(text, "(.......coffee).$", %{}) == {:ok, "cup of coffee"}
    end

    test "handles 'captures'", %{text: text} do
      assert Regex.m(text, ~S"By.+(\d\d)", %{}) == {:ok, "51"}
      assert Regex.m(text, ~S"By.*(1\d).*?(\d)", %{}) == {:ok, "17\n3"}
    end

    test "returns empty string when there is no match" do
      assert Regex.m("foo", "bar", %{}) == {:ok, ""}
    end

    test "errors when the regex is bad" do
      assert Regex.m("one\ntwo", "?", %{}) == {:error, "Mc.Modifier.Regex: bad regex"}
    end

    test "works with ok tuples" do
      assert Regex.m({:ok, "some buffer text"}, "me.*uf", %{}) == {:ok, "me buf"}
    end

    test "allows error tuples to pass through" do
      assert Regex.m({:error, "reason"}, "gets ignored", %{}) == {:error, "reason"}
    end
  end
end
