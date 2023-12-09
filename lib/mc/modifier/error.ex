defmodule Mc.Modifier.Error do
  use Mc.Railway, [:modify]

  def modify(_buffer, args, _mappings) do
    {:error, args}
  end
end
