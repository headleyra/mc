defmodule Mc.Modifier.Invert do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.join("\n")
    }
  end
end
