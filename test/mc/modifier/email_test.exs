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
      assert Email.modify("hi", "subj") == {:error, "Mc.Modifier.Email#modify: missing subject and/or recipients"}
      assert Email.modify("hi", "") == {:error, "Mc.Modifier.Email#modify: missing subject and/or recipients"}
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
