defmodule Mc.Modifier.Appendk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.modify("", "get #{args}") do
      {:ok, data} ->
        {:ok, buffer <> data}

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
