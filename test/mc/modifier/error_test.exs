defmodule Mc.Modifier.ErrorTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Error

  describe "Mc.Modifier.Error.modify/2" do
    test "returns an error tuple" do
      assert Error.modify("n/a", "message") == {:error, "message"}
      assert Error.modify("", "ka\nboom") == {:error, "ka\nboom"}
    end

    test "returns a help message" do
      assert Check.has_help?(Error, :modify)
    end

    test "errors with unknown switches" do
      assert Error.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Error#modify: switch parse error"}
      assert Error.modify("", "-u") == {:error, "Mc.Modifier.Error#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Error.modify({:ok, "buffer"}, "blah") == {:error, "blah"}
    end

    test "allows error tuples to pass through" do
      assert Error.modify({:error, "boom!"}, "black coffee") == {:error, "boom!"}
    end
  end
end
