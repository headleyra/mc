defmodule Mc.Modifier.Trim do
  use Mc.Railway, [:modify, :modifyn]

  def modify(buffer, _args) do
    result = String.trim(buffer)
    {:ok, result}
  end

  def modifyn(buffer, _args) do
    result = String.trim(buffer, "\n")
    {:ok, result}
  end
end
