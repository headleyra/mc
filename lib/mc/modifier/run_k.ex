defmodule Mc.Modifier.RunK do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.m("get #{args}", mappings) do
      {:ok, script} ->
        buffer
        |> Mc.m(script, mappings)
        |> oops(:script_error, script)

      error ->
        oops(:key_not_found, args, error)
    end
  end
end
