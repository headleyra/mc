defmodule Mc.Modifier.UrlP do
  use Mc.Modifier

  def m(_buffer, args, mappings) do
    case url_params(args, mappings) do
      {:ok, url_params} ->
        fetch(url_params)

      _error ->
        oops(:bad_params_list, args)
    end
  end

  defp url_params(args, mappings) do
    case String.split(args, ~r/\s+/, parts: 2) do
      [""] ->
        :error

      ["", ""] ->
        :error

      [url] ->
        {:ok, [url, []]}

      [url, params] ->
        argsize(url, params, mappings)
    end
  end

  defp argsize(url, params, mappings) do
    case params_list(params, mappings) do
      {:ok, params_list} ->
        {:ok, [url, params_list]}

      _error ->
        :error
    end
  end

  defp fetch(url_params) do
    case apply(adapter(), :post, url_params) do
      {:ok, result} ->
        {:ok, result}

      {:error, _reason} ->
        oops(:adapter_error, nil)
    end
  end

  defp params_list(params, mappings) do
    params
    |> split()
    |> validate()
    |> listize(mappings)
  end

  defp split(params) do
    String.split(params)
  end

  defp validate(params_list) do
    valid = Enum.all?(params_list, fn params_pair -> String.match?(params_pair, ~r/[^\s]+:[^\s]+/) end)
    if valid, do: params_list, else: false
  end

  defp listize(false, _mappings), do: :error

  defp listize(params_list, mappings) do
    {:ok,
      params_list
      |> Enum.map(fn params_pair -> String.split(params_pair, ":") end)
      |> Enum.map(fn [param_name, key] -> param_value(param_name, key, mappings) end)
      |> Keyword.new(fn e -> detuple(e) end)
    }
  end

  defp param_value(param_name, key, mappings) do
     {String.to_atom(param_name), Mc.m("get #{key}", mappings)}
  end

  defp detuple({atom, {:ok, value}}), do: {atom, value}
  defp detuple({atom, {:error, _, _, _, _}}), do: {atom, ""}

  defp adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
