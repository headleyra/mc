defmodule Mc.Modifier.Ucase do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    result = String.upcase(buffer)
    {:ok, result}
  end
end
