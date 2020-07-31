defmodule Mc.Modifier.EmailTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Email

  defmodule Postee do
    use Mc.MailerInterface
  end

  setup do
    start_supervised({Email, Postee})
    :ok
  end

  describe "Mc.Modifier.Email.mailer_impl_module/0" do
    test "returns the mailer implementation module" do
      assert Email.mailer_impl_module() == Postee
    end
  end

  describe "Mc.Modifier.Email.deliver/2" do
    test "parses `args` and delegates to the configured module" do
      assert Email.deliver("a message", "a subject, ale@example.net beer@example.org") == {
        "a subject",
        "a message",
        ["ale@example.net", "beer@example.org"]
      }
    end

    test "returns an error tuple when subject and/or recipients are missing" do
      assert Email.deliver("hi", "subj") == {:error, "Email: subject and/or recipients missing"}
      assert Email.deliver("hi", "") == {:error, "Email: subject and/or recipients missing"}
    end

    test "works with ok tuples" do
      assert Email.deliver({:ok, "a great read"}, "re: something, a@example.org") == {
        "re: something",
        "a great read",
        ["a@example.org"]
      }
    end

    test "allows error tuples to pass-through unchanged" do
      assert Email.deliver({:error, "reason"}, "subj, b@example.net") == {:error, "reason"}
    end
  end
end
