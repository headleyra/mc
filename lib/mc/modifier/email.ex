defmodule Mc.Modifier.Email do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(mail_client: mail_client) do
    Agent.start_link(fn -> mail_client end, name: __MODULE__)
  end

  def mail_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(buffer, args) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        recipient_list = String.split(recipients)
        apply(mail_client(), :deliver, [subject, buffer, recipient_list])

      _bad_args ->
        oops(:modify, "missing subject and/or recipients")
    end
  end
end
