defmodule Mc.X.Summarize do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Integer.parse(args) do
      {ratio, _} ->
        {:ok, api_key} = Mc.modify("", "get api_key")
        Mc.Util.WebClient.post(endpoint(), %{text: buffer, ratio: ratio, api_key: api_key})

      :error ->
        {:error, "Summarize: bad ratio"}
    end
  end

  def endpoint do
    System.get_env("SUMMARIZE_ENDPOINT")
  end
end
