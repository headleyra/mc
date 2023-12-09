defmodule Mc.Modifier.Prependk do
  use Mc.Railway, [:modify]

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, data <> buffer}

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
