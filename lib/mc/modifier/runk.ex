defmodule Mc.Modifier.Runk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.modify("", "get #{args}") do
      {:ok, script} ->
        Mc.modify(buffer, script)

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
