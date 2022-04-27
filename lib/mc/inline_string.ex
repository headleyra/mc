defmodule Mc.InlineString do
  def decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
    |> uri_decode()
  end

  def uri_decode(string) do
    {:ok, URI.decode(string)}
  end
end
