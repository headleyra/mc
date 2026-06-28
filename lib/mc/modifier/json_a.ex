defmodule Mc.Modifier.JsonA do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    parse_list(buffer)
  end

  defp parse_list(buffer) do
    case Jason.decode(buffer) do
      {:ok, array} when is_list(array) ->
        {:ok, Enum.map_join(array, "\n", fn element -> Jason.encode!(element) end)}

      {:ok, array} when is_map(array) or is_nil(array) ->
        {:ok, ""}

      {:error, _} ->
        oops(:bad_json, buffer)
    end
  end
end
