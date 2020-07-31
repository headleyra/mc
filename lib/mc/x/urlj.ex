defmodule Mc.X.Urlj do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    if String.match?(args, ~r/^[a-z]+/) do
      {:ok, api_key} = Mc.modify("", "get api_key")
      Mc.Util.WebClient.post(endpoint(), %{url: args, api_key: api_key})
    else
      {:error, "Urlj: bad URL"}
    end
  end

  def endpoint do
    System.get_env("URLJ_ENDPOINT")
  end
end
