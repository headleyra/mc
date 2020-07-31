defmodule Mc.Modifier.Sort do
  use Mc.Railway, [:modify, :modifyv]

  def modify(buffer, _args) do
    {:ok, sorter(buffer, :asc)}
  end

  def modifyv(buffer, _args) do
    {:ok, sorter(buffer, :dsc)}
  end

  def sorter(text, order) do
    func =
      case order do
        :asc -> (& &1 <= &2)
        :dsc -> (& &1 >= &2)
      end

    text
    |> String.split("\n")
    |> Enum.sort(func)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
