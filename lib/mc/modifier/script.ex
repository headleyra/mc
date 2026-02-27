defmodule Mc.Modifier.Script do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    script =
      args
      |> Mc.Parse.split()
      |> Enum.join("\n")

    Mc.m(buffer, script, mappings)
  end
end
