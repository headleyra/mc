defmodule Mc.Test.MailAdapter do
  @behaviour Mc.Behaviour.MailAdapter

  def deliver("trigger-error", _message, _recipients), do: {:error, "email error"}

  def deliver(subject, message, recipients) do
    {:ok, {subject, message, recipients}}
  end
end
