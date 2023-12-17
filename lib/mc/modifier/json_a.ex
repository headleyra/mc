defmodule Mc.Modifier.JsonA do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    parse_list(buffer)
  end

  defp parse_list(buffer) do
    case Jason.decode(buffer) do
      {:ok, array} when is_list(array) ->
        {:ok,
          array
          |> Enum.map(&Jason.encode!(&1))
          |> Enum.join("\n")
        }

      {:ok, array} when is_map(array) or is_nil(array) ->
        {:ok, ""}

      {:error, _} ->
        oops("bad JSON")
    end
  end
end
