defmodule Mc.Modifier.StopTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Stop

  describe "modify/3" do
    test "halts the execution chain; returns its `buffer`" do
      assert Stop.modify("foo", "n/a", %{}) == {:ok, "foo"}
      assert Stop.modify("bar", "", %{}) == {:ok, "bar"}
    end

    test "works with ok tuples" do
      assert Stop.modify({:ok, "radio"}, "", %{}) == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert Stop.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
