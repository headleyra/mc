defmodule Mc.Http do
  @timeout 40_000
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.10 Safari/605.1.1"

  def request(url) do
    base_request(url)
  end

  def parse(response) do
    case response do
      {:ok, %Req.Response{status: 404}} ->
        {:error, "http 404"}

      {:ok, %Req.Response{body: body}} ->
        {:ok, body}

      {:error, reason} ->
        {:error, inspect(reason)}
    end
  end

  defp base_request(url) do
    Req.new(url: url, decode_body: false, headers: %{timeout: @timeout, user_agent: @user_agent})
  end
end
