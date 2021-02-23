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
    end

    test "errors with fewer than two numbers" do
      assert Math.add("", "") == {:error, "Mc.Modifier.Math#add: fewer than two numbers found"}
      assert Math.add("8", "") == {:error, "Mc.Modifier.Math#add: fewer than two numbers found"}
      assert Math.add("foo bar", "") == {:error, "Mc.Modifier.Math#add: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.add({:ok, "3\n4"}, "") == {:ok, "7"}
    end

    test "allows error tuples to pass-through" do
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
    end

    test "errors with fewer than two numbers" do
      assert Math.subtract("", "") == {:error, "Mc.Modifier.Math#subtract: fewer than two numbers found"}
      assert Math.subtract("1", "") == {:error, "Mc.Modifier.Math#subtract: fewer than two numbers found"}
      assert Math.subtract("foo bar", "") == {:error, "Mc.Modifier.Math#subtract: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.subtract({:ok, "3\n4"}, "") == {:ok, "-1"}
    end

    test "allows error tuples to pass-through" do
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
    end

    test "errors with fewer than two numbers" do
      assert Math.multiply("", "") == {:error, "Mc.Modifier.Math#multiply: fewer than two numbers found"}
      assert Math.multiply("2", "") == {:error, "Mc.Modifier.Math#multiply: fewer than two numbers found"}
      assert Math.multiply("foo bar", "") == {:error, "Mc.Modifier.Math#multiply: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.multiply({:ok, "3\n4"}, "") == {:ok, "12"}
    end

    test "allows error tuples to pass-through" do
      assert Math.multiply({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.divide/2" do
    test "is able to 'divide' the `buffer`" do
      assert Math.divide("21\n3", "n/a") == {:ok, "7.0"}
      assert Math.divide("radio\n\n2\n4\n\n", "") == {:ok, "0.5"}
      assert Math.divide(" 3 4", "") == {:ok, "0.75"}
      assert Math.divide("\n   -30.0\t 3  4.0", "") == {:ok, "-2.5"}
    end

    test "errors with fewer than two numbers" do
      assert Math.divide("", "") == {:error, "Mc.Modifier.Math#divide: fewer than two numbers found"}
      assert Math.divide("5", "") == {:error, "Mc.Modifier.Math#divide: fewer than two numbers found"}
      assert Math.divide("foo bar", "") == {:error, "Mc.Modifier.Math#divide: fewer than two numbers found"}
    end

    test "works with ok tuples" do
      assert Math.divide({:ok, "3\n4"}, "") == {:ok, "0.75"}
    end

    test "allows error tuples to pass-through" do
      assert Math.divide({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Math.applyop/2" do
    test "applies the given operation to the given string" do
      assert Math.applyop("1\n7", :+) == {:ok, "8"}
      assert Math.applyop("3 \t4.1", :+) == {:ok, "7.1"}
      assert Math.applyop("4 1", :-) == {:ok, "3"}
      assert Math.applyop("2\n0.5\t0.5", :-) == {:ok, "1.0"}
      assert Math.applyop("4.2 2", :*) == {:ok, "8.4"}
      assert Math.applyop("2 4 5", :*) == {:ok, "40"}
      assert Math.applyop("4.0 2.0", :/) == {:ok, "2.0"}
      assert Math.applyop("10 2 2", :/) == {:ok, "2.5"}
    end

    test "returns error with fewer than two numbers" do
      assert Math.applyop("7", :+) == :error
      assert Math.applyop("", :+) == :error
      assert Math.applyop("-1", :-) == :error
      assert Math.applyop("", :-) == :error
      assert Math.applyop("5", :*) == :error
      assert Math.applyop("", :*) == :error
      assert Math.applyop("4.0", :/) == :error
      assert Math.applyop("", :/) == :error
    end
  end
end
