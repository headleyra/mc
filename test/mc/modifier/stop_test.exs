defmodule Mc.Modifier.StopTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Stop

  describe "m/3" do
    test "halts the execution chain; returns its `buffer`" do
      assert Stop.m("foo", "n/a", %{}) == {:ok, "foo"}
      assert Stop.m("bar", "", %{}) == {:ok, "bar"}
    end

    test "works with ok tuples" do
      assert Stop.m({:ok, "radio"}, "", %{}) == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert Stop.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
