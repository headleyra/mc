defmodule Mc.Modifier.Ucase do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    {:ok, String.upcase(buffer)}
  end
end
