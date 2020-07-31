defmodule Mc.Util.WebClient do
  use Mc.WebClientInterface
  @user_agent "Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0"
  @http_options [recv_timeout: 11_000]

  def get(url) do
    HTTPoison.get(url, ["User-Agent": @user_agent], @http_options)
    |> reply_for(url)
  end

  def post(url, params_map) do
    HTTPoison.post(url, post_data(params_map), post_header(@user_agent), @http_options)
    |> reply_for(url)
  end

  def reply_for(response, url) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "#{url} (404)"}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def post_data(params_map) do
    {:form, Map.to_list(params_map)}
  end

  def post_header(user_agent) do
    ["Content-Type": "application/x-www-form-urlencoded", "User-Agent": user_agent]
  end
end
