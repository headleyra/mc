defmodule Mc.Modifier.Http do
  use Agent
  use Mc.Railway, [:get, :post]
  @argspec "<url> {<param name>:<payload key> }"

  def start_link(http_client: http_client) do
    Agent.start_link(fn -> http_client end, name: __MODULE__)
  end

  def http_client do
    Agent.get(__MODULE__, & &1)
  end

  def get(_buffer, args) do
    apply(http_client(), :get, [args])
  end

  def post(_buffer, ""), do: usage(:post, @argspec)

  def post(_buffer, args) do
    case build_url_params(args) do
      :error ->
        usage(:post, @argspec)

      url_params ->
        apply(http_client(), :post, url_params)
    end
  end

  def build_params(params) do
    create_params_list(params)
    |> validate()
    |> keywordify()
  end

  def build_url_params(url_params) do
    case String.split(url_params, ~r/\s+/, parts: 2) do
      [""] ->
        :error

      [url] ->
        [url, []]

      [url, params] ->
        case build_params(params) do
          :error ->
            :error

          params_list ->
            [url, params_list]
        end
    end
  end

  defp create_params_list(params) do
    String.split(params)
    |> Enum.map(fn param_pairs -> String.split(param_pairs, ":") end)
  end

  defp validate(params_list) do
    valid =
      Enum.all?(params_list, fn param_pair ->
        Enum.count(param_pair) == 2 && Enum.all?(param_pair, &(&1 != ""))
      end)

    if valid, do: params_list, else: false
  end

  defp keywordify(false), do: :error

  defp keywordify(params_list) do
    params_list
    |> Enum.map(fn [param_name, kv_key] -> {String.to_atom(param_name), kv_key} end)
    |> Keyword.new(fn {param_name_atom, kv_key} ->
      {:ok, kv_value} = Mc.modify("", "get #{kv_key}")
      {param_name_atom, kv_value}
    end)
  end
end
