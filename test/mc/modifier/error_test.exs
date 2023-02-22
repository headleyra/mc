defmodule Mc.Modifier.ErrorTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Error

  describe "modify/2" do
    test "returns an error tuple" do
      assert Error.modify("n/a", "message") == {:error, "message"}
      assert Error.modify("", "ka\nboom") == {:error, "ka\nboom"}
    end

    test "works with ok tuples" do
      assert Error.modify({:ok, "buffer"}, "blah") == {:error, "blah"}
    end

    test "allows error tuples to pass through" do
      assert Error.modify({:error, "boom!"}, "black coffee") == {:error, "boom!"}
    end
  end
end
