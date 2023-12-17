defmodule Mc.Modifier.RunK do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, script} ->
        Mc.modify(buffer, script, mappings)

      {:error, "not found"} ->
        {:ok, buffer}
    end
  end
end
