defmodule Mc.Modifier.Error do
  use Mc.Modifier

  def m(_buffer, args, _mappings) do
    {:error, args}
  end
end
