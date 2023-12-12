defmodule Mc.Modifier.EmailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Email

  describe "modify/3" do
    test "parses `args` and calls `deliver` on its mail adapter" do
      assert Email.modify("a message", "a subject, ale@example.net beer@example.org", %{}) ==
        {:ok, {"a subject", "a message", ["ale@example.net", "beer@example.org"]}}
    end

    test "errors when subject and/or recipients are missing" do
      assert Email.modify("hi", "subj", %{}) ==
        {:error, "Mc.Modifier.Email: missing subject and/or recipients"}

      assert Email.modify("hi", "", %{}) ==
        {:error, "Mc.Modifier.Email: missing subject and/or recipients"}
    end

    test "works with ok tuples" do
      assert Email.modify({:ok, "a great read"}, "that book, a@example.org", %{}) ==
        {:ok, {"that book", "a great read", ["a@example.org"]}}
    end

    test "allows error tuples to pass through" do
      assert Email.modify({:error, "reason"}, "subj, b@example.net", %{}) == {:error, "reason"}
    end
  end
end
