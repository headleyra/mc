defmodule Mc.Modifier.AppS do
  use Mc.Modifier

  def m(_buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        {:ok, script}

      {:error, :not_found, key} ->
        oops(:not_found, key)

      {:error, :missing_app_key, key} ->
        oops(:missing_app_key, key)
    end
  end
end
