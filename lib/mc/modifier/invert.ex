defmodule Mc.Modifier.Invert do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.join("\n")
    }
  end
end
