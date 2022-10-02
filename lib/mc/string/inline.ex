defmodule Mc.String.Inline do
  def decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
    |> Mc.Uri.decode()
  end
end
