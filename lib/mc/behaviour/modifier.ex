defmodule Mc.Behaviour.Modifier do
  @type buffer :: String.t | {:ok, result} | {:error, reason}
  @type args :: String.t
  @type mappings :: Map.t
  @type result :: String.t
  @type reason :: String.t

  @callback modify(buffer, args, mappings) :: {:ok, result} | {:error, reason}
end
