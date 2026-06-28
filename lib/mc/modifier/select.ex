defmodule Mc.Modifier.Select do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    buffer
    |> Mc.Modifier.Field.m("#{args} %0a %0a", mappings)
    |> oops(:parse_error, args)
  end
end
