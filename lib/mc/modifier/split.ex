defmodule Mc.Modifier.Split do
  use Mc.Railway, [:modify]

  def modify(buffer, ""), do: {:ok, String.split(buffer) |> Enum.join("\n")}

  def modify(buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        {:ok, String.split(buffer, regex) |> Enum.join("\n")}

      {:error, _} ->
        oops(:modify, "bad regex")
    end
  end
end
