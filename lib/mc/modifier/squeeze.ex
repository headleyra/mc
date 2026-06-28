defmodule Mc.Modifier.Squeeze do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.map(fn line -> String.replace(line, ~r/\s\s+/, " ") end)
      |> Enum.map_join("\n", fn squashed_line -> String.trim(squashed_line) end)
    }
  end
end
