defmodule Mc.Modifier.HeadTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Head

  setup do
    %{
      text: """
      line one
      line 2

      line three
      """
    }
  end

  describe "Mc.Modifier.Head.modify/2" do
    test "returns the first `args` lines", %{text: text} do
      assert Head.modify(text, "1") == {:ok, "line one"}
      assert Head.modify(text, "2") == {:ok, "line one\nline 2"}
      assert Head.modify(text, "3") == {:ok, "line one\nline 2\n"}
      assert Head.modify(text, "4") == {:ok, "line one\nline 2\n\nline three"}
      assert Head.modify("\n\nleading\nempties", "3") == {:ok, "\n\nleading"}
    end

    test "returns `buffer` if `args` exceeds lines present", %{text: text} do
      assert Head.modify(text, "8") == {:ok, "line one\nline 2\n\nline three\n"}
    end

    test "returns empty string when `args` is zero", %{text: text} do
      assert Head.modify(text, "0") == {:ok, ""}
    end

    test "errors when `args` is negative", %{text: text} do
      assert Head.modify(text, "-1") == {:error, "usage: head <positive integer>"}
    end

    test "errors when `args` is not an integer", %{text: text} do
      assert Head.modify(text, "hi") == {:error, "usage: head <positive integer>"}
      assert Head.modify(text, "") == {:error, "usage: head <positive integer>"}
    end

    test "works with ok tuples" do
      assert Head.modify({:ok, "some\nbuffer\ntext"}, "2") == {:ok, "some\nbuffer"}
    end

    test "allows error tuples to pass-through" do
      assert Head.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end
end
