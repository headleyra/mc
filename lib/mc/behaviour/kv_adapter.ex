defmodule Mc.Behaviour.KvAdapter do
  @type key :: String.t
  @type value :: String.t
  @type regex :: String.t
  @type result :: String.t
  @type reason :: String.t

  @callback get(key) :: {:ok, result} | {:error, reason} | {:error, :not_found}
  @callback set(key, value) :: {:ok, result} | {:error, reason}
  @callback findk(regex) :: {:ok, result} | {:error, reason}
  @callback findv(regex) :: {:ok, result} | {:error, reason}
  @callback delete(key) :: {:ok, result} | {:error, reason} | {:error, :not_found}
end
