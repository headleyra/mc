defmodule Mc.Modifier.Script do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    script =
      args
      |> Ut.Parse.split()
      |> Enum.join("\n")

    buffer
    |> Mc.m(script, mappings)
    |> oops(:script_error, args)
  end
end
