defmodule Mc.Modifier.Get do
  use Agent
  use Mc.Railway, [:modify]

  @help """
  modifier <key>
  modifier -h

  Retrieves the buffer stored under <key>.

  -h, --help
    Show help
  """

  def start_link(kv_client: kv_client) do
    Agent.start_link(fn -> kv_client end, name: __MODULE__)
  end

  def kv_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(_buffer, args) do
    case parse(args) do
      {_, []} ->
        apply(kv_client(), :get, [args])

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end
end
