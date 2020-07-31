defmodule Mc.Util.MathTest do
  use ExUnit.Case, async: true
  alias Mc.Util.Math

  describe "Mc.Util.Math.str2num/1" do
    test "converts its argument to an integer" do
      assert Math.str2num("0") == 0
      assert Math.str2num("-2") == -2
      assert Math.str2num("22") == 22
    end

    test "converts its argument to a float" do
      assert Math.str2num("0.0") == 0.0
      assert Math.str2num("-0.81") == -0.81
      assert Math.str2num("3.142") == 3.142
    end
  end

  describe "Mc.Util.Math.str2int/1" do
    test "converts its argument to an integer" do
      assert Math.str2int("0") == 0
      assert Math.str2int("-81") == -81
      assert Math.str2int("5") == 5
    end

    test "returns :error for non-integer strings" do
      assert Math.str2int("") == :error
      assert Math.str2int("0.0") == :error
      assert Math.str2int("beans") == :error
      assert Math.str2int("^5") == :error
    end
  end

  describe "Mc.Util.Math.str2flt/1" do
    test "converts its argument to a float" do
      assert Math.str2flt("0.0") == 0.0
      assert Math.str2flt("-22.04") == -22.04
      assert Math.str2flt("101.9") == 101.9
    end

    test "returns :error for non-float strings" do
      assert Math.str2flt("") == :error
      assert Math.str2flt("8") == :error
      assert Math.str2flt("foo") == :error
      assert Math.str2flt("3..2") == :error
      assert Math.str2flt("4!6") == :error
    end
  end
end
