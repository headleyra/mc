defmodule Mc.String.Inline do
  def decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
  end
end
