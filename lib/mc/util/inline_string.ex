defmodule Mc.Util.InlineString do
  def decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
    |> uri_decode()
  end

  def uri_decode(string) do
    try do
      {:ok, URI.decode(string)}
    rescue
      ArgumentError ->
        :error
    end
  end
end
