defmodule Mc.Modifier.Lcase do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, String.downcase(buffer)}
  end
end
