defmodule Mc.Modifier.GetB do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    {:ok, buffer}
  end
end
