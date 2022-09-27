defmodule Mc.Modifier.Error do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    {:error, args}
  end
end
