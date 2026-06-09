defmodule Mc.Modifier.SetM do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    separator = Mc.Const.kv_separator(args)

    case Ut.Kv.string_to_kv_list(buffer, separator) do
      {:ok, kv_list} ->
        Enum.each(kv_list, fn {key, value} -> Mc.m(value, "set #{key}", mappings) end)

      {:error, :bad_format} ->
        oops("bad format")
    end
  end
end
