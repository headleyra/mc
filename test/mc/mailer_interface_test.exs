defmodule Mc.MailerInterfaceTest do
  use ExUnit.Case, async: true

  defmodule Post do
    use Mc.MailerInterface
  end

  defmodule PostOverride do
    use Mc.MailerInterface
    def deliver(subject, message, recipient_list), do: {:overridden, subject, message, recipient_list}
  end

  describe "Mc.MailerInterface" do
    test "defines a default `deliver/3` function" do
      assert Post.deliver("subject", "message", ["recipient list"]) ==
        {"subject", "message", ["recipient list"]}
    end

    test "allows `deliver/3` to be overridden" do
      assert PostOverride.deliver("subject", "message", ["recipient list"]) ==
        {:overridden, "subject", "message", ["recipient list"]}
    end
  end
end
