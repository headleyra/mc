defmodule Mc.Modifier.Map do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(fn buffer -> Mc.m(buffer, args, mappings) end)
      |> Enum.map_join("\n", fn result -> detuple(result) end)
    }
  end

  defp detuple({:ok, result}), do: result
  defp detuple({:error, Mc.Modifier.Unknown, _, modifier_name, _}), do: "ERROR: modifier unknown: #{modifier_name}"
  defp detuple({:error, _, _, message, _}), do: "ERROR: #{message}"
end
