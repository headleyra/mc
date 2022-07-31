defmodule Mc.Modifier.EmailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Email

  defmodule Postee do
    @behaviour Mc.Behaviour.MailClient
    def deliver(subject, message, recipients), do: {:ok, {subject, message, recipients}}
  end

  setup do
    start_supervised({Email, mail_client: Postee})
    :ok
  end

  describe "Mc.Modifier.Email.mail_client/0" do
    test "returns the mail client implementation" do
      assert Email.mail_client() == Postee
    end
  end

  describe "Mc.Modifier.Email.modify/2" do
    test "parses `args` and delegates to the implementation" do
      assert Email.modify("a message", "a subject, ale@example.net beer@example.org") ==
        {:ok, {"a subject", "a message", ["ale@example.net", "beer@example.org"]}}
    end

    test "errors when subject and/or recipients are missing" do
      assert Email.modify("hi", "subj") == {:error, "usage: Mc.Modifier.Email#modify <subject>, <email> ..."}
      assert Email.modify("hi", "") == {:error, "usage: Mc.Modifier.Email#modify <subject>, <email> ..."}
    end

    test "returns a help message" do
      assert Check.has_help?(Email, :modify)
    end

    test "errors with unknown switches" do
      assert Email.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Email#modify: switch parse error"}
      assert Email.modify("", "-u") == {:error, "Mc.Modifier.Email#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Email.modify({:ok, "a great read"}, "that book, a@example.org") ==
      {:ok, {"that book", "a great read", ["a@example.org"]}}
    end

    test "allows error tuples to pass through" do
      assert Email.modify({:error, "reason"}, "subj, b@example.net") == {:error, "reason"}
    end
  end
end
