defmodule Mc.Behaviour.KvClient do
  @type key :: String.t
  @type value :: String.t
  @type regex :: String.t
  @type result :: String.t
  @type reason :: String.t

  @callback get(pid, key) :: {:ok, result} | {:error, reason}
  @callback set(pid, key, value) :: {:ok, result} | {:error, reason}
  @callback findk(pid, regex) :: {:ok, result} | {:error, reason}
  @callback findv(pid, regex) :: {:ok, result} | {:error, reason}
end
