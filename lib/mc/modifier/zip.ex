defmodule Mc.Modifier.Zip do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    zip(buffer, args, mappings)
  end

  defp zip(buffer, script, mappings) do
    case Mc.modify(buffer, script, mappings) do
      {:ok, zipee} ->
        buffer_list = String.split(buffer, "\n")
        script_list = String.split(zipee, "\n")

        {:ok,
          Enum.zip(buffer_list, script_list)
          |> Enum.map_join("\n", fn {a, b} -> "#{a}#{b}" end)
        }

      {:error, reason} ->
        oops(reason)
    end
  end
end
