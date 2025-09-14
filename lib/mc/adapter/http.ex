defmodule Mc.Adapter.Http do
  @behaviour Mc.Behaviour.HttpAdapter
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.10 Safari/605.1.1"
  @timeout 40_000

  @impl true
  def get(url) do
    url
    |> base_request()
    |> Req.get()
    |> parse()
  end

  @impl true
  def post(url, params_list) do
    url
    |> base_request()
    |> Req.post(form: params_list)
    |> parse()
  end

  defp base_request(url) do
    Req.new(url: url, decode_body: false, headers: %{timeout: @timeout, user_agent: @user_agent})
  end

  defp parse(response) do
    case response do
      {:ok, %Req.Response{status: 404}} ->
        {:error, "http 404"}

      {:ok, %Req.Response{body: body}} ->
        {:ok, body}

      {:error, reason} ->
        {:error, inspect(reason)}
    end
  end
end
