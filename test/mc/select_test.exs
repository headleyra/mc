defmodule Mc.SelectTest do
  use ExUnit.Case, async: true
  alias Mc.Select

  describe "parse/1" do
    test "parses a 'select spec' into a zero-indexed list" do
      assert Select.parse("1") == [0]
      assert Select.parse("2,5") == [1, 4]
      assert Select.parse("2-4,8") == [[1, 2, 3], 7]
      assert Select.parse("11,11-15,98") == [10, [10, 11, 12, 13, 14], 97]
      assert Select.parse("1-3,8-5") == [[0, 1, 2], [7, 6, 5, 4]]
      assert Select.parse("8-8") == [[7]]
    end

    test "errors with zeroes" do
      assert Select.parse("0") == :error
      assert Select.parse("0-3") == :error
      assert Select.parse("7,0") == :error
    end

    test "errors with negatives" do
      assert Select.parse("1-3,-7-1") == :error
      assert Select.parse("-3") == :error
      assert Select.parse("-1-3") == :error
    end

    test "errors with non-integers" do
      assert Select.parse("3.1") == :error
      assert Select.parse("1 two") == :error
      assert Select.parse("foo bar") == :error
      assert Select.parse("") == :error
      assert Select.parse("\t") == :error
      assert Select.parse(" \n") == :error
    end
  end
end
