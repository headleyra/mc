defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Prepend

  describe "Mc.Modifier.Prepend.modify/2" do
    test "parses `args` as an inline string and prepends it to the buffer" do
      assert Prepend.modify("12", "3") == {:ok, "312"}
      assert Prepend.modify(".foo\n", "bar") == {:ok, "bar.foo\n"}
      assert Prepend.modify("3 foo", "1; 2") == {:ok, "1\n23 foo"}
      assert Prepend.modify("at the border", "stop; %20") == {:ok, "stop\n at the border"}
      assert Prepend.modify("1\n2", "0 %%0a") == {:ok, "0 %\n1\n2"}
    end

    test "works with ok tuples" do
      assert Prepend.modify({:ok, "best"}, "exit ") == {:ok, "exit best"}
    end

    test "allows error tuples to pass-through" do
      assert Prepend.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
