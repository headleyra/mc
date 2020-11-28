defmodule Mc.Modifier.Http do
  use Agent
  use Mc.Railway, [:get, :post]
  @err_msg "http (POST): bad args"

  def start_link(http_client) do
    Agent.start_link(fn -> http_client end, name: __MODULE__)
  end

  def http_client do
    Agent.get(__MODULE__, & &1)
  end

  def get(_buffer, args) do
    apply(http_client(), :get, [args])
  end

  def post(_buffer, ""), do: {:error, @err_msg}

  def post(_buffer, args) do
    case build_url_params(args) do
      :error ->
        {:error, @err_msg}

      url_params ->
        apply(http_client(), :post, url_params)
    end
  end

  def build_params(params_string) do
    create_params_list(params_string)
    |> validate()
    |> keyword_listify()
  end

  def build_url_params(url_params_string) do
    case String.split(url_params_string, ~r/\s+/, parts: 2) do
      [""] ->
        :error

      [url] ->
        [url, []]

      [url, params_string] ->
        case build_params(params_string) do
          :error ->
            :error

          params_map ->
            [url, params_map]
        end
    end
  end

  defp create_params_list(params_string) do
    String.split(params_string)
    |> Enum.map(fn param_pairs -> String.split(param_pairs, ":") end)
  end

  defp validate(params_list) do
    valid? =
      Enum.all?(params_list, fn e ->
        Enum.count(e) == 2 && Enum.all?(e, &(&1 != ""))
      end)

    {valid?, params_list}
  end

  # TODO: Use Map.reduce
  defp keyword_listify({valid?, params_list}) do
    if valid? do
      params_list
      |> Enum.map(fn [param_name, kv_key] -> {String.to_atom(param_name), kv_key} end)
      |> Keyword.new(fn {param_name_atom, kv_key} ->
        {:ok, kv_value} = Mc.modify("", "get #{kv_key}")
        {param_name_atom, kv_value}
      end)
    else
      :error
    end
  end
end
