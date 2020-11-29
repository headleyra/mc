defmodule Mc.Modifier.If do
  use Mc.Railway, [:modifye, :modifyl, :modifyg]

  def modifye(buffer, args) do
    compare(buffer, args, fn a, b -> a == b end)
  end

  def modifyl(buffer, args) do
    compare(buffer, args, fn a, b -> a < b end)
  end

  def modifyg(buffer, args) do
    compare(buffer, args, fn a, b -> a > b end)
  end

  defp compare(buffer, args, func) do
    case String.split(args) do
      [compare_key, true_key, false_key] ->
        {:ok, compare_value} = Mc.modify("", "get #{compare_key}")

        if func.(buffer, compare_value) do
          {:ok, true_script} = Mc.modify("", "get #{true_key}")
          Mc.modify(buffer, true_script)
        else
          {:ok, false_script} = Mc.modify("", "get #{false_key}")
          Mc.modify(buffer, false_script)
        end

      _bad_args ->
        {:error, "If: Bad args"}
    end
  end
end
