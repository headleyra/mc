defmodule Mc.Modifier.RunK do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, script} ->
        Mc.modify(buffer, script, mappings)

      {:error, reason} ->
        oops(reason)
    end
  end
end
