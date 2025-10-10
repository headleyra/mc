defmodule Mc.Modifier.UrlP do
  use Mc.Modifier

  def modify(_buffer, args, mappings) do
    case build_url_with_params(args, mappings) do
      {:ok, url_with_params} ->
        fetch(url_with_params)

      _error ->
        oops("parse error")
    end
  end

  defp fetch(url_with_params) do
    case apply(adapter(), :post, url_with_params) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason} ->
        oops(reason)
    end
  end

  defp build_url_with_params(args, mappings) do
    case String.split(args, ~r/\s+/, parts: 2) do
      [""] ->
        :error

      ["", ""] ->
        :error

      [url] ->
        {:ok, [url, []]}

      [url, params] ->
        argsify(url, params, mappings)
    end
  end

  defp argsify(url, params, mappings) do
    case build_params_list(params, mappings) do
      {:ok, params_list} ->
        {:ok, [url, params_list]}

      _error ->
        :error
    end
  end

  defp build_params_list(params, mappings) do
    params
    |> split()
    |> validate()
    |> listify(mappings)
  end

  defp validate(params_list) do
    valid = Enum.all?(params_list, fn params_pair -> String.match?(params_pair, ~r/[^\s]+:[^\s]+/) end)
    if valid, do: params_list, else: false
  end

  defp split(params) do
    String.split(params)
  end

  defp listify(false, _mappings), do: :error
  defp listify(params_list, mappings) do
    {:ok,
      params_list
      |> Enum.map(fn params_pair -> String.split(params_pair, ":") end)
      |> Enum.map(fn [param_name, key] -> {String.to_atom(param_name), Mc.modify("", "get #{key}", mappings)} end)
      |> Keyword.new(&build_keyword_list/1)
    }
  end

  defp build_keyword_list({atom, {:ok, value}}), do: {atom, value}
  defp build_keyword_list({atom, {:error, _reason}}), do: {atom, ""}

  defp adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
