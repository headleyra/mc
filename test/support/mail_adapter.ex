defmodule Mc.Test.MailAdapter do
  @behaviour Mc.Behaviour.MailAdapter

  def deliver(subject, message, recipients) do
    {:ok, {subject, message, recipients}}
  end
end
