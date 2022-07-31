defmodule Mc.Modifier.Urlp do
  use Agent
  use Mc.Railway, [:modify]

  @help """
  modifier <URL> {<param_name>:<key of payload> }
  modifier -h

  Sends an HTTP post request.

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
        http_post(args)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp http_post(args) do
    case build_url_with_params(args) do
      {:ok, url_with_params} ->
        apply(http_client(), :post, url_with_params)

      _error ->
        oops(:modify, "parse error")
    end
  end

  def build_url_with_params(args) do
    case String.split(args, ~r/\s+/, parts: 2) do
      [""] ->
        :error

      ["", ""] ->
        :error

      [url] ->
        {:ok, [url, []]}

      [url, params] ->
        argsify(url, params)
    end
  end

  defp argsify(url, params) do
    case build_params_list(params) do
      {:ok, params_list} ->
        {:ok, [url, params_list]}

      _error ->
        :error
    end
  end

  def build_params_list(params) do
    params
    |> split()
    |> validate()
    |> listify()
  end

  defp validate(params_list) do
    valid = Enum.all?(params_list, fn params_pair -> String.match?(params_pair, ~r/[^\s]+:[^\s]+/) end)
    if valid, do: params_list, else: false
  end

  defp split(params) do
    String.split(params)
  end

  defp listify(false), do: :error

  defp listify(params_list) do
    {:ok,
      params_list
      |> Enum.map(fn params_pair -> String.split(params_pair, ":") end)
      |> Enum.map(fn [param_name, key] -> {String.to_atom(param_name), Mc.modify("", "get #{key}")} end)
      |> Keyword.new(fn {param_name_atom, {:ok, value}} -> {param_name_atom, value} end)
    }
  end
end
