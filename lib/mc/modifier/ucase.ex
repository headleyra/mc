defmodule Mc.Modifier.Ucase do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, String.upcase(buffer)}
  end
end
