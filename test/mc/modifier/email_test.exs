defmodule Mc.Modifier.EmailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Email

  describe "Mc.Modifier.Email.mailer/0" do
    test "returns the mailer implementation" do
      assert Email.mailer() == Postee
    end
  end

  describe "Mc.Modifier.Email.deliver/2" do
    test "parses `args` and delegates to the implementation" do
      assert Email.deliver("a message", "a subject, ale@example.net beer@example.org") ==
        {:ok, {"a subject", "a message", ["ale@example.net", "beer@example.org"]}}
    end

    test "errors when subject and/or recipients are missing" do
      assert Email.deliver("hi", "subj") == {:error, "usage: email <subject>, <email> ..."}
      assert Email.deliver("hi", "") == {:error, "usage: email <subject>, <email> ..."}
    end

    test "works with ok tuples" do
      assert Email.deliver({:ok, "a great read"}, "re: something, a@example.org") ==
      {:ok, {"re: something", "a great read", ["a@example.org"]}}
    end

    test "allows error tuples to pass-through" do
      assert Email.deliver({:error, "reason"}, "subj, b@example.net") == {:error, "reason"}
    end
  end
end
