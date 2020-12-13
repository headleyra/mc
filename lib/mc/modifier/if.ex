defmodule Mc.Modifier.If do
  use Mc.Railway, [:modifye, :modifyl, :modifyg]

  def modifye(buffer, args) do
    compare(buffer, args, fn a, b -> a == b end, :modifye)
  end

  def modifyl(buffer, args) do
    compare(buffer, args, fn a, b -> a < b end, :modifyl)
  end

  def modifyg(buffer, args) do
    compare(buffer, args, fn a, b -> a > b end, :modifyg)
  end

  defp compare(buffer, args, compare_func, from_func) do
    case String.split(args) do
      [compare_key, true_key, false_key] ->
        {:ok, compare_value} = Mc.modify("", "get #{compare_key}")

        if compare_func.(buffer, compare_value) do
          {:ok, true_script} = Mc.modify("", "get #{true_key}")
          Mc.modify(buffer, true_script)
        else
          {:ok, false_script} = Mc.modify("", "get #{false_key}")
          Mc.modify(buffer, false_script)
        end

      _bad_args ->
        usage(from_func, "<compare key> <true key> <false key>")
    end
  end
end
