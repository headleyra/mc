defmodule Mc.Adapter.Http do
  @behaviour Mc.Behaviour.HttpAdapter

  @impl true
  def get(url) do
    fetch(url, fn req -> Req.get(req) end)
  end

  @impl true
  def post(url, params_list) do
    fetch(url, fn req -> Req.post(req, form: params_list) end)
  end

  defp fetch(url, func) do
    try do
      url
      |> Mc.Http.request()
      |> func.()
      |> Mc.Http.decode()
    rescue
      e in ArgumentError -> error(e.message)
    end
  end

  defp error(message) do
    cond do
      String.starts_with?(message, "scheme is required for url") -> {:error, "missing scheme"}
      true -> {:error, "scheme not supported"}
    end
  end
end
