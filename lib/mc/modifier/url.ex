defmodule Mc.Modifier.Url do
  use Agent
  use Mc.Railway, [:modify]

  @help """
  modifier <URL>
  modifier -h

  Fetches the HTML of <URL>.

  -h, --help
    Show help
  """

  def start_link(http_client: http_client) do
    Agent.start_link(fn -> http_client end, name: __MODULE__)
  end

  def http_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(_buffer, args) do
    case parse(args) do
      {_, []} ->
        apply(http_client(), :get, [args])

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
