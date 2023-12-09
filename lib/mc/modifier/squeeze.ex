defmodule Mc.Modifier.Squeeze do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(&String.replace(&1, ~r/\s\s+/, " "))
      |> Enum.map(&String.trim(&1))
      |> Enum.join("\n")
    }
  end
end
