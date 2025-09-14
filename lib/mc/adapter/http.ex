defmodule Mc.Adapter.Http do
  @behaviour Mc.Behaviour.HttpAdapter

  @impl true
  def get(url) do
    url
    |> Mc.Http.request()
    |> Req.get()
    |> Mc.Http.parse()
  end

  @impl true
  def post(url, params_list) do
    url
    |> Mc.Http.request()
    |> Req.post(form: params_list)
    |> Mc.Http.parse()
  end
end
