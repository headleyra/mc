defmodule Mc.Modifier.Sort do
  use Mc.Railway, [:modify, :modifyv]

  def modify(buffer, _args) do
    {:ok, sorta(buffer)}
  end

  def modifyv(buffer, _args) do
    {:ok, sortd(buffer)}
  end

  def sorta(text), do: sorter(text, &(&1 <= &2))
  def sortd(text), do: sorter(text, &(&1 >= &2))

  defp sorter(text, func) do
    text
    |> String.split("\n")
    |> Enum.sort(func)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
