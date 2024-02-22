defmodule Mc.Modifier.App do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        Mc.modify(buffer, script, mappings)

      {:error, :not_found, key} ->
        oops("not found: #{key}")
    end
  end
end
