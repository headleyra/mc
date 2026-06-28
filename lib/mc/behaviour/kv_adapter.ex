defmodule Mc.Behaviour.KvAdapter do
  @type key :: binary()
  @type value :: binary()
  @type regex :: binary()
  @type result :: binary()
  @type reason :: atom()

  @callback get(key) :: {:ok, result} | {:error, reason}
  @callback set(key, value) :: {:ok, result} | {:error, reason}
  @callback findk(regex) :: {:ok, result} | {:error, reason}
  @callback findv(regex) :: {:ok, result} | {:error, reason}
  @callback delete(key) :: {:ok, result} | {:error, reason}
end
