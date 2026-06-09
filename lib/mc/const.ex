defmodule Mc.Const do
  def kv_separator(separator) do
    if separator == "" do
      "\n---\n"
    else
      URI.decode(separator)
    end
  end
end
