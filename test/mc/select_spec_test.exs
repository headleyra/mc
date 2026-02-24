defmodule Mc.SelectSpecTest do
  use ExUnit.Case, async: true
  alias Mc.SelectSpec

  describe "parse/1" do
    test "parses a 'select spec' into a zero-indexed list" do
      assert SelectSpec.parse("1") == [0]
      assert SelectSpec.parse("2,5") == [1, 4]
      assert SelectSpec.parse("2-4,8") == [[1, 2, 3], 7]
      assert SelectSpec.parse("11,11-15,98") == [10, [10, 11, 12, 13, 14], 97]
      assert SelectSpec.parse("1-3,8-5") == [[0, 1, 2], [7, 6, 5, 4]]
      assert SelectSpec.parse("8-8") == [[7]]
    end

    test "errors with zeroes" do
      assert SelectSpec.parse("0") == :error
      assert SelectSpec.parse("0-3") == :error
      assert SelectSpec.parse("7,0") == :error
    end

    test "errors with negatives" do
      assert SelectSpec.parse("1-3,-7-1") == :error
      assert SelectSpec.parse("-3") == :error
      assert SelectSpec.parse("-1-3") == :error
    end

    test "errors with non-integers" do
      assert SelectSpec.parse("3.1") == :error
      assert SelectSpec.parse("1 two") == :error
      assert SelectSpec.parse("foo bar") == :error
      assert SelectSpec.parse("") == :error
      assert SelectSpec.parse("\t") == :error
      assert SelectSpec.parse(" \n") == :error
    end
  end
end
