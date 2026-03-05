defmodule Mc.Modifier.Split do
  use Mc.Modifier

  def m(buffer, "", _mappings), do: split(buffer, " ")
  def m(buffer, args, _mappings), do: split(buffer, args)

  defp split(buffer, uri_encoded_str) do
    str = URI.decode(uri_encoded_str)

    {:ok,
      buffer
      |> String.split(str)
      |> Enum.join("\n")
    }
  end
end
