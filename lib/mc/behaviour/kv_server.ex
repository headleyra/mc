defmodule Mc.Behaviour.KvServer do
  @type buffer :: String.t | {:ok, result} | {:error, reason}
  @type args :: String.t
  @type result :: String.t
  @type reason :: String.t

  @callback set(buffer, args) :: {:ok, result} | {:error, reason}
  @callback get(buffer, args) :: {:ok, result} | {:error, reason}
  @callback appendk(buffer, args) :: {:ok, result} | {:error, reason}
  @callback prependk(buffer, args) :: {:ok, result} | {:error, reason}
  @callback find(buffer, args) :: {:ok, result} | {:error, reason}
  @callback findv(buffer, args) :: {:ok, result} | {:error, reason}
end
