defmodule Mc.Modifier.If do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    ife(buffer, args)
  end

  defp ife(buffer, args) do
    with \
      [compare_key, true_key, false_key] <- String.split(args),
      {:ok, compare_value} = Mc.modify("", "get #{compare_key}")
    do
      if buffer == compare_value, do: runkey(buffer, true_key), else: runkey(buffer, false_key)
    else
      _bad_args ->
        oops(:modify, "parse error")
    end
  end

  defp runkey(buffer, key) do
    Mc.modify(buffer, "runk #{key}")
  end
end
