defmodule Mc.StringTest do
  use ExUnit.Case, async: true
  alias Mc.String

  describe "Mc.String.numberize/1" do
    test "converts its input into a list of numbers" do
      assert String.numberize("1") == [1]
      assert String.numberize("no numbers") == []
      assert String.numberize("") == []
      assert String.numberize(" \n\t ") == []
      assert String.numberize("cash 7") == [7]
      assert String.numberize("pi 3.142\nabc 123") == [3.142, 123]
      assert String.numberize("foo  -4.3\n2\t1\n0  bar") == [-4.3, 2, 1, 0]
    end
  end

  describe "Mc.String.count_char/2" do
    test "counts the number occurences of a specific character" do
      assert String.count_char("aa", "a") == 2
      assert String.count_char("abba plays pop", "a") == 3
      assert String.count_char("dosh", "x") == 0
      assert String.count_char("a new\n\nparagraph", "\n") == 2
      assert String.count_char("", "") == 0
      assert String.count_char("'single", "'") == 1
      assert String.count_char("double\"", "\"") == 1
    end
  end
end
