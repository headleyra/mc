defmodule Mc.Modifier.Split do
  use Mc.Modifier

  def m(buffer, "", _mappings), do: split(buffer)
  def m(buffer, args, _mappings), do: split(buffer, args)

  defp split(buffer) do
    buffer
    |> String.split()
    |> join()
  end

  defp split(buffer, uri_encoded_splitter) do
    splitter = URI.decode(uri_encoded_splitter)

    buffer
    |> String.split(splitter)
    |> join()
  end

  defp join(lines) do
    {:ok, Enum.join(lines, "\n")}
  end
end
