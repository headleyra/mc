defmodule Mc.Modifier.Appendk do
  use Mc.Railway, [:modify]

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, buffer <> data}

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
