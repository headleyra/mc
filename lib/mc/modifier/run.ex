defmodule Mc.Modifier.Run do
  use Mc.Modifier

  def m(buffer, _args, mappings) do
    buffer
    |> Mc.m(mappings)
    |> oops(:script_error, buffer)
  end
end
