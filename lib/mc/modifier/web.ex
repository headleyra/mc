defmodule Mc.Modifier.Web do
  use Agent
  use Mc.Railway, [:get, :post]
  @err_msg "Web (POST): bad args"

  def start_link(web_client_impl_module) do
    Agent.start_link(fn -> web_client_impl_module end, name: __MODULE__)
  end

  def web_client_impl_module do
    Agent.get(__MODULE__, & &1)
  end

  def get(_buffer, args) do
    apply(web_client_impl_module(), :get, [args])
  end

  def post(_buffer, ""), do: {:error, @err_msg}
  def post(_buffer, args) do
    case build_url_params(args) do
      :error ->
        {:error, @err_msg}

      call_args ->
        apply(web_client_impl_module(), :post, call_args)
    end
  end

  # TODO: Refactor
  def build_params(params_string) do
    params_list =
      String.split(params_string)
      |> Enum.map(fn(param_pairs) -> String.split(param_pairs, ":") end)

    ok_params = Enum.all?(params_list, fn(e) ->
      Enum.count(e) == 2 && Enum.all?(e, fn(x) -> x != "" end)
    end)

    if ok_params do
      params_list
      |> Enum.map(fn([param_name, kv_key]) -> [String.to_atom(param_name), kv_key] end)
      |> Map.new(fn([param_name_atom, kv_key]) ->
        {:ok, kv_value} = Mc.modify("", "get #{kv_key}")
        {param_name_atom, kv_value}
      end)
    else
      :error
    end
  end

  # TODO: Refactor
  def build_url_params(url_params_string) do
    case String.split(url_params_string) do
      [] ->
        :error

      [url] ->
        [url, %{}]

      [url | params_list] ->
        params_string = Enum.join(params_list, " ")
        case build_params(params_string) do
          :error ->
            :error
          params_map ->
            [url, params_map]
        end
    end
  end
end
