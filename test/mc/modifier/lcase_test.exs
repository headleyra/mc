defmodule Mc.Modifier.LcaseTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Lcase

  describe "Mc.Modifier.Lcase.modify/2" do
    test "downcases the `buffer`" do
      assert Lcase.modify("FOO Bar", "n/a") == {:ok, "foo bar"}
    end

    test "works with ok tuples" do
      assert Lcase.modify({:ok, "BEST\nOF 3"}, "n/a") == {:ok, "best\nof 3"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Lcase.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
