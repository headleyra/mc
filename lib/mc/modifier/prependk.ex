defmodule Mc.Modifier.Prependk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.modify("", "get #{args}") do
      {:ok, data} ->
        {:ok, data <> buffer}

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
