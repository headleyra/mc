defmodule Mc.Modifier.Split do
  use Mc.Railway, [:modify]
  @argspec "<regex>"

  def modify(buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        result = String.split(buffer, regex) |> Enum.join("\n")
        {:ok, result}

      {:error, _} ->
        usage(:modify, @argspec)
    end
  end
end
