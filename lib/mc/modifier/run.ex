defmodule Mc.Modifier.Run do
  use Mc.Railway, [:modify]

  @help """
  modifier
  modifier -k <key>
  modifier -h

  Treats buffer as a script and runs it.

  -k <key>, --key <key>
    Runs the script referenced by <key> against the buffer

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        Mc.modify("", buffer)

      {_, [key: key]} ->
        {:ok, script} = Mc.modify("", "get #{key}")
        Mc.modify(buffer, script)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:key, :string, :k}, {:help, :boolean, :h}])
  end
end
