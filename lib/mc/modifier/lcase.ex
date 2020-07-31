defmodule Mc.Modifier.Lcase do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    result = String.downcase(buffer)
    {:ok, result}
  end
end
