defmodule Mc.Modifier.GetM do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    keys = String.split(buffer)
    {:ok, kv_list} = Ut.Kv.keys_to_kv_list(keys, fn key -> key_value(key, mappings) end)

    separator = Mc.Const.kv_separator(args)
    result = Enum.map_join(kv_list, separator, fn {key, value} -> "#{key}\n#{value}" end)

    {:ok, result}
  end

  defp key_value(key, mappings) do
    case Mc.m("get #{key}", mappings) do
      {:ok, value} ->
        value

      {:error, _, :key_not_found, _, []} ->
        ""
    end
  end
end
