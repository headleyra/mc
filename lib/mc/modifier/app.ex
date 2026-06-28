defmodule Mc.Modifier.App do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.App.script(args, mappings) do
      {:ok, script} ->
        Mc.m(buffer, script, mappings)

      {:error, :not_found, key} ->
        oops(:app_key_not_found, key)

      {:error, :missing_app_key, nil} ->
        oops(:missing_app_key, nil)
    end
  end
end
