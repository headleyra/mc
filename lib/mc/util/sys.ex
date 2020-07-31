defmodule Mc.Util.Sys do
  def decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
    |> uri_decode()
  end

  defp uri_decode(string) do
    try do
      URI.decode(string)
    rescue
      ArgumentError ->
        {:error, ""}
    end
  end

  def writeable_key?(key) do
    String.match?(key, ~r/^_/)
  end
end
