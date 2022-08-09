defmodule Mc.Modifier.Email do
  use Agent
  use Mc.Railway, [:modify]

  @help """
  modifier <subject>, {<email recipient>}
  modifier -h

  Sends the buffer as an email.

  -h, --help
    Show help
  """

  def start_link(mail_client: mail_client) do
    Agent.start_link(fn -> mail_client end, name: __MODULE__)
  end

  def mail_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        deliver(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp deliver(buffer, args) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        recipient_list = String.split(recipients)
        apply(mail_client(), :deliver, [subject, buffer, recipient_list])

      _bad_args ->
        usage(:modify, "<subject>, <email> ...")
    end
  end
end
