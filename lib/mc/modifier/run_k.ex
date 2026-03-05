defmodule Mc.Modifier.RunK do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.m("", "get #{args}", mappings) do
      {:ok, script} ->
        Mc.m(buffer, script, mappings)

      {:error, reason} ->
        oops(reason)
    end
  end
end
