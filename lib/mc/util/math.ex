defmodule Mc.Util.Math do
  def str2num(string) do
    case str2int(string) do
      :error ->
        str2flt(string)

      ok_tuple ->
        ok_tuple
    end
  end

  def str2int(string) do
    try do
      {:ok, String.to_integer(string)}
    rescue
      ArgumentError ->
        :error
    end
  end

  def str2flt(string) do
    try do
      {:ok, String.to_float(string)}
    rescue
      ArgumentError ->
        :error
    end
  end
end
