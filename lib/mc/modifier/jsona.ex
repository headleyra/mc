defmodule Mc.Modifier.Jsona do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
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
        oops(:modify, "bad JSON")
    end
  end
end
