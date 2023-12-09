defmodule Mc.Modifier.Getb do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    {:ok, buffer}
  end
end
