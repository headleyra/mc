defmodule Mc.Modifier.Email do
  use Agent
  use Mc.Railway, [:deliver]

  def start_link(mailer) do
    Agent.start_link(fn -> mailer end, name: __MODULE__)
  end

  def mailer do
    Agent.get(__MODULE__, & &1)
  end

  def deliver(buffer, args) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        recipient_list = String.split(recipients)
        apply(mailer(), :deliver, [subject, buffer, recipient_list])

      _bad_args ->
        {:error, "Email: subject and/or recipients missing"}
    end
  end
end
