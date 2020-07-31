defmodule Mc.Modifier.AppendTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Append

  describe "Mc.Modifier.Append.modify/2" do
    test "appends `args`, in 'inline format', to the buffer" do
      assert Append.modify("12", "3") == {:ok, "123"}
      assert Append.modify("foo\n", "bar") == {:ok, "foo\nbar"}
      assert Append.modify("foo\n", "bar; roo") == {:ok, "foo\nbar\nroo"}
      assert Append.modify("the tab", "%09; tub") == {:ok, "the tab\t\ntub"}
    end

    test "returns an error tuple given badly formed URI characters" do
      assert Append.modify("the buff", "%%0a") == {:error, "Append: bad URI"}
    end

    test "works with ok tuples" do
      assert Append.modify({:ok, "best\nof "}, "three") == {:ok, "best\nof three"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Append.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
