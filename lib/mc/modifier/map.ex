defmodule Mc.Modifier.Map do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(&Mc.m(&1, args, mappings))
      |> Enum.map_join("\n", &detuple/1)
    }
  end

  defp detuple({:ok, result}), do: result
  defp detuple({:error, reason}), do: "ERROR: #{reason}"
end
