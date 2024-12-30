defmodule Mc.Modifier.Squeeze do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(&String.replace(&1, ~r/\s\s+/, " "))
      |> Enum.map_join("\n", &String.trim(&1))
    }
  end
end
