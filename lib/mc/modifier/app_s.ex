defmodule Mc.Modifier.AppS do
  use Mc.Modifier

  def modify(_buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        {:ok, script}

      {:error, :not_found, key} ->
        oops("not found: #{key}")
    end
  end
end
