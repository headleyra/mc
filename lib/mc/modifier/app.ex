defmodule Mc.Modifier.App do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        Mc.modify(buffer, script, mappings)

      {:error, :not_found} ->
        oops("app not found")
    end
  end
end
