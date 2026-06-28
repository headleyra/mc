defmodule Mc.Modifier.ErrorTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Error

  describe "m/3" do
    test "returns an error-tuple" do
      assert Error.m("n/a", "message", %{}) == {:error, Mc.Modifier.Error, :error, "message", []}
      assert Error.m("", "ka\nboom", %{}) == {:error, Mc.Modifier.Error, :error, "ka\nboom", []}
    end

    test "works with ok-tuples" do
      assert Error.m({:ok, "stuff"}, "blah", %{}) == {:error, Mc.Modifier.Error, :error, "blah", []}
    end

    test "allows error-tuples to pass through" do
      assert Error.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
