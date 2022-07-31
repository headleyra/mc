defmodule Mc.Modifier.SortTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sort

  describe "Mc.Modifier.Sort.modify/2" do
    test "sorts the `buffer` in ascending order" do
      assert Sort.modify("apple\nzoom\n0-rated\nbanana", "") == {:ok, "0-rated\napple\nbanana\nzoom"}
    end

    test "sorts the `buffer` in descending order ('inverse' switch)" do
      assert Sort.modify("a\nc\nb", "--inverse") == {:ok, "c\nb\na"}
      assert Sort.modify("a\nc\nb", "-v") == {:ok, "c\nb\na"}
      assert Sort.modify("10\nten\ndix", "-v") == {:ok, "ten\ndix\n10"}
    end

    test "returns a help message" do
      assert Check.has_help?(Sort, :modify)
    end

    test "errors with unknown switches" do
      assert Sort.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Sort#modify: switch parse error"}
      assert Sort.modify("n/a", "-u") == {:error, "Mc.Modifier.Sort#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Sort.modify({:ok, "banana\napple"}, "") == {:ok, "apple\nbanana"}
    end

    test "allows error tuples to pass through" do
      assert Sort.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Sort.parse/1" do
    test "parses its input for the 'inverse' switch" do
      assert Sort.parse("--inverse") == {"", [inverse: true]}
      assert Sort.parse("-v") == {"", [inverse: true]}
      assert Sort.parse("-v foo") == {"foo", [inverse: true]}
      assert Sort.parse("") == {"", []}
      assert Sort.parse("foo") == {"foo", []}
    end

    test "errors given unknown switches" do
      assert Sort.parse("-u") == :error
      assert Sort.parse("--unknown opt") == :error
      assert Sort.parse("--nope") == :error
    end
  end
end
