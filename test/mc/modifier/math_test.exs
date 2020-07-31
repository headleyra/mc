defmodule Mc.Modifier.MathTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Math

  describe "Mc.Modifier.Math.add/2" do
    test "is able to 'add' the `buffer`" do
      assert Math.add("1\n7", "n/a") == {:ok, "8"}
      assert Math.add("foo bar\n\n1\n4\n\n", "") == {:ok, "5"}
      assert Math.add(" 3 4", "") == {:ok, "7"}
      assert Math.add("\n   3.4\t 4  11", "") == {:ok, "18.4"}
      assert Math.add("\n1.23\n4\n", "") == {:ok, "5.23"}
      assert Math.add("", "") == {:error, "Add: fewer than two numbers found"}
      assert Math.add("8", "") == {:error, "Add: fewer than two numbers found"}
      assert Math.add("foo bar", "") == {:error, "Add: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.add({:ok, "3\n4"}, "") == {:ok, "7"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Math.add({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.subtract/2" do
    test "is able to 'subtract' the `buffer`" do
      assert Math.subtract("17\n3", "n/a") == {:ok, "14"}
      assert Math.subtract("bosh\n\n2\n4\n\n", "") == {:ok, "-2"}
      assert Math.subtract(" 3 4", "") == {:ok, "-1"}
      assert Math.subtract("\n   1.1\t 4  5", "") == {:ok, "-7.9"}
      assert Math.subtract("4\n1.23", "") == {:ok, "2.77"}
      assert Math.subtract("", "") == {:error, "Sub: fewer than two numbers found"}
      assert Math.subtract("1", "") == {:error, "Sub: fewer than two numbers found"}
      assert Math.subtract("foo bar", "") == {:error, "Sub: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.subtract({:ok, "3\n4"}, "") == {:ok, "-1"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Math.subtract({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.multiply/2" do
    test "is able to 'multiply' the `buffer`" do
      assert Math.multiply("3\n17", "n/a") == {:ok, "51"}
      assert Math.multiply("light\n\n2\n4\n\n", "") == {:ok, "8"}
      assert Math.multiply(" 3 4", "") == {:ok, "12"}
      assert Math.multiply("\n   1.1\t 4  5", "") == {:ok, "22.0"}
      assert Math.multiply("\n1.23\n4\n", "") == {:ok, "4.92"}
      assert Math.multiply("", "") == {:error, "Mul: fewer than two numbers found"}
      assert Math.multiply("2", "") == {:error, "Mul: fewer than two numbers found"}
      assert Math.multiply("foo bar", "") == {:error, "Mul: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.multiply({:ok, "3\n4"}, "") == {:ok, "12"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Math.multiply({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.divide/2" do
    test "is able to 'divide' the `buffer`" do
      assert Math.divide("21\n3", "n/a") == {:ok, "7.0"}
      assert Math.divide("radio\n\n2\n4\n\n", "") == {:ok, "0.5"}
      assert Math.divide(" 3 4", "") == {:ok, "0.75"}
      assert Math.divide("\n   -30.0\t 3  4.0", "") == {:ok, "-2.5"}
      assert Math.divide("", "") == {:error, "Div: fewer than two numbers found"}
      assert Math.divide("5", "") == {:error, "Div: fewer than two numbers found"}
      assert Math.divide("foo bar", "") == {:error, "Div: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.divide({:ok, "3\n4"}, "") == {:ok, "0.75"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Math.divide({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.apply_func/2" do
    test "applies the given 'function' to a string (ignoring white space)" do
      assert Math.apply_func("1\n7", "Add") == {:ok, "8"}
      assert Math.apply_func("3 \t4.1", "Add") == {:ok, "7.1"}
      assert Math.apply_func("4 1", "Sub") == {:ok, "3"}
      assert Math.apply_func("2\n0.5\t0.5", "Sub") == {:ok, "1.0"}
      assert Math.apply_func("4.2 2", "Mul") == {:ok, "8.4"}
      assert Math.apply_func("2 4 5", "Mul") == {:ok, "40"}
      assert Math.apply_func("4.0 2.0", "Div") == {:ok, "2.0"}
      assert Math.apply_func("10 2 2", "Div") == {:ok, "2.5"}
    end

    test "returns an error tuple with fewer than 2 numbers" do
      assert Math.apply_func("7", "Add") == {:error, "Add: fewer than two numbers found"}
      assert Math.apply_func("", "Add") == {:error, "Add: fewer than two numbers found"}
      assert Math.apply_func("-1", "Sub") == {:error, "Sub: fewer than two numbers found"}
      assert Math.apply_func("", "Sub") == {:error, "Sub: fewer than two numbers found"}
      assert Math.apply_func("5", "Mul") == {:error, "Mul: fewer than two numbers found"}
      assert Math.apply_func("", "Mul") == {:error, "Mul: fewer than two numbers found"}
      assert Math.apply_func("4.0", "Div") == {:error, "Div: fewer than two numbers found"}
      assert Math.apply_func("", "Div") == {:error, "Div: fewer than two numbers found"}
    end
  end
end
