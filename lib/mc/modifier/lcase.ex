defmodule Mc.Modifier.Lcase do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    {:ok, String.downcase(buffer)}
  end
end
