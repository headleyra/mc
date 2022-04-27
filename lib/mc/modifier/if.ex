defmodule Mc.Modifier.If do
  use Mc.Railway, [:modify, :modifye]

  def modify(buffer, args) do
    case String.split(args) do
      [script_key] ->
        if String.match?(buffer, ~r/^\s*$/), do: get(buffer, script_key), else: {:ok, buffer}

      _bad_args ->
        usage(:modify, "<script key>")
    end
  end

  def modifye(buffer, args) do
    with \
      [compare_key, true_key, false_key] <- String.split(args),
      {:ok, compare_value} = Mc.modify("", "get #{compare_key}")
    do
      if buffer == compare_value, do: get(buffer, true_key), else: get(buffer, false_key)
    else
      _bad_args ->
        usage(:modifye, "<compare key> <true key> <false key>")
    end
  end

  defp get(buffer, key) do
    {:ok, script} = Mc.modify("", "get #{key}")
    Mc.modify(buffer, script)
  end
end
