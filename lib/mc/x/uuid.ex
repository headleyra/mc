defmodule Mc.X.Uuid do
  use Mc.Railway, [:modify]

  def modify(_buffer, _args) do
    result = UUID.uuid4()
    {:ok, result}
  end
end
