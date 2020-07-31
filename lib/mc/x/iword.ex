defmodule Mc.X.Iword do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    {:ok, api_key} = Mc.modify("", "get api_key")

    case Integer.parse(buffer) do
      {int, _} when int >= 0 ->
        case Mc.Util.WebClient.post(endpoint(), %{x: buffer, api_key: api_key}) do
          {:ok, result_json} ->
            {:ok, result_map} = Jason.decode(result_json)
            {:ok, result_map |> Map.get("iw")}

          {:error, reason} ->
            {:error, reason}
        end

      {_negative, _} ->
        {:error, "Iword: negative"}

      :error ->
        {:error, "Iword: not an integer"}
    end
  end

  def endpoint do
    System.get_env("IWORD_ENDPOINT")
  end
end
