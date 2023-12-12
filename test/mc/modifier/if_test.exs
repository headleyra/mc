defmodule Mc.Modifier.IfTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.If

  describe "modify/3" do
    test "compares `buffer` and 'a-value'; returns 'true-value' if equal, 'false-value' if not" do
      assert If.modify("a-value", "a-value true-value false-value", %{}) == {:ok, "true-value"}
      assert If.modify("nope", "nah true-value false-value", %{}) == {:ok, "false-value"}
    end

    test "works with URI encoded values" do
      assert If.modify("new\nbuffer", "new%0abuffer true%09value false-value", %{}) == {:ok, "true\tvalue"}
      assert If.modify("123", "123-not true-value false%25value", %{}) == {:ok, "false%value"}
    end

    test "compares as whitespace (or empty string) when no compare value is given" do
      assert If.modify("", "true false", %{}) == {:ok, "true"}
      assert If.modify("   ", "true false", %{}) == {:ok, "true"}
      assert If.modify("\t\n", "true false", %{}) == {:ok, "true"}
      assert If.modify(".  ", "true false", %{}) == {:ok, "false"}
    end

    @errmsg "Mc.Modifier.If: parse error"

    test "errors without exactly 2 or 3 values" do
      assert If.modify("n/a", "just-one", %{}) == {:error, @errmsg}
      assert If.modify("", "one two three four", %{}) == {:error, @errmsg}
      assert If.modify("", "", %{}) == {:error, @errmsg}
      assert If.modify("", "1 2 3 4 5", %{}) == {:error, @errmsg}
    end

    test "works with ok tuples" do
      assert If.modify({:ok, "aaa"}, "aaa true false", %{}) == {:ok, "true"}
    end

    test "allows error tuples to pass through" do
      assert If.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
