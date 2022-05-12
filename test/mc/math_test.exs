defmodule Mc.MathTest do
  use ExUnit.Case, async: true
  alias Mc.Math

  describe "Mc.Math.str2num/1" do
    test "converts its argument to an integer" do
      assert Math.str2num("0") == {:ok, 0}
      assert Math.str2num("-2") == {:ok, -2}
      assert Math.str2num("22") == {:ok, 22}
    end

    test "converts its argument to a float" do
      assert Math.str2num("0.0") == {:ok, 0.0}
      assert Math.str2num("-0.81") == {:ok, -0.81}
      assert Math.str2num("3.142") == {:ok, 3.142}
    end

    test "errors for non-number strings" do
      assert Math.str2num("") == :error
      assert Math.str2num(".0") == :error
      assert Math.str2num("apple") == :error
      assert Math.str2num("%5") == :error
    end
  end

  describe "Mc.Math.str2int/1" do
    test "converts its argument to an integer" do
      assert Math.str2int("0") == {:ok, 0}
      assert Math.str2int("-81") == {:ok, -81}
      assert Math.str2int("5") == {:ok, 5}
    end

    test "errors for non-integer strings" do
      assert Math.str2int("") == :error
      assert Math.str2int("0.0") == :error
      assert Math.str2int("beans") == :error
      assert Math.str2int("^5") == :error
    end
  end

  describe "Mc.Math.str2flt/1" do
    test "converts its argument to a float" do
      assert Math.str2flt("0.0") == {:ok, 0.0}
      assert Math.str2flt("-22.04") == {:ok, -22.04}
      assert Math.str2flt("101.9") == {:ok, 101.9}
    end

    test "errors for non-float strings" do
      assert Math.str2flt("") == :error
      assert Math.str2flt("8") == :error
      assert Math.str2flt("foo") == :error
      assert Math.str2flt("3..2") == :error
      assert Math.str2flt("4!6") == :error
    end
  end
end
