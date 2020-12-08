defmodule Mc.Modifier.Invert do
  use Mc.Railway, [:modify]

  def modify("", _args), do: {:ok, ""}

  def modify(buffer, _args) do
    result =
      buffer
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.join("\n")

    {:ok, result}
  end
end
