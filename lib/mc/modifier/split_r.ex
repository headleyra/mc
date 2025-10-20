defmodule Mc.Modifier.SplitR do
  use Mc.Modifier

  def modify(buffer, "", _mappings), do: split(buffer, "\\s+")
  def modify(buffer, args, _mappings), do: split(buffer, args)

  defp split(buffer, regex_str) do
    case Regex.compile(regex_str) do
      {:ok, regex} ->
        {:ok,
          buffer
          |> String.split(regex)
          |> Enum.join("\n")
        }

      {:error, _} ->
        oops("bad regex")
    end
  end
end
