defmodule Mc.Modifier.AppS do
  use Mc.Modifier

  def modify(_buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        {:ok, script}

      {:error, :not_found} ->
        oops("app not found")
    end
  end
end
