defmodule Mc.Modifier.Join do
  use Mc.Railway, [:modify]

  def modify(buffer, ""), do: {:ok, String.split(buffer, "\n") |> Enum.join()}

  def modify(buffer, args) do
    case Mc.Util.InlineString.uri_decode(args) do
      {:ok, seperator} ->
        {:ok, String.split(buffer, "\n") |> Enum.join(seperator)}

      _error ->
        usage(:modify, "<uri encoded separator>")
    end
  end
end
