defmodule Mc.Modifier.Trim do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, String.trim(buffer)}
  end
end
