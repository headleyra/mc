defmodule Mc.Modifier.Find do
  use Agent
  use Mc.Railway, [:modify]

  @help """
  modifier [-v] <regex>
  modifier -h

  Finds keys matching the given <regex>.

  -v, --value
    Finds keys with values matching the given <regex>.

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
        apply(kv_client(), :findk, [args])
        |> resultify()

      {args_pure, [value: true]} ->
        apply(kv_client(), :findv, [args_pure])
        |> resultify()

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:value, :boolean, :v}, {:help, :boolean, :h}])
  end

  defp resultify(tuple) do
    case tuple do
      {:ok, result} -> {:ok, result}
      {:error, _} -> oops(:modify, "bad regex")
    end
  end
end
