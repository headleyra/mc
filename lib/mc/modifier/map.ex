defmodule Mc.Modifier.Map do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(&Mc.modify(&1, args, mappings))
      |> Enum.map(&detuple/1)
      |> Enum.join("\n")
    }
  end

  defp detuple({:ok, result}), do: result
  defp detuple({:error, reason}), do: "ERROR: #{reason}"
end
