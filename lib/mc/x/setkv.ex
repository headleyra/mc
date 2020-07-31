defmodule Mc.X.Setkv do
  use Mc.Railway, [:modify, :modify!]

  def modify(buffer, args) do
    doit(buffer, args, false)
  end

  def modify!(buffer, args) do
    doit(buffer, args, true)
  end

  def doit(buffer, args, overwrite) do
    try do
      separator = if args == "", do: "\n---\n", else: args
      String.split(buffer, URI.decode(separator))
      |> Enum.map(fn(e) -> kv2tuple(e) end)
      |> kvset(overwrite)

      {:ok, buffer}
    rescue ArgumentError ->
      {:error, "Setkv: bad URI"}
    end
  end

  def kv2tuple(kv_text) do
    case String.split(kv_text, "\n", parts: 2) do
      [key, value] ->
        {key, value}
      _error ->
        nil
    end
  end

  def kvset(kv_tuple_list, overwrite) do
    set_suffix = if overwrite, do: "!", else: ""

    if Enum.all?(kv_tuple_list) do
      Enum.each(kv_tuple_list, fn({key, value}) -> Mc.modify(value, "set#{set_suffix} #{key}") end)
    else
      {:error, "SetKv: bad KVs"}
    end
  end
end
