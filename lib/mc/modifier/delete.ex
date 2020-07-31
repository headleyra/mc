defmodule Mc.Modifier.Delete do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        result = String.replace(buffer, regex, "")
        {:ok, result}

      {:error, _} ->
        {:error, "Delete: bad regex"}
    end
  end
end
