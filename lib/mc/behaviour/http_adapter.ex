defmodule Mc.Behaviour.HttpAdapter do
  @type url :: String.t
  @type params :: [{atom, String.t}]
  @type reply :: String.t
  @type reason :: String.t

  @callback get(url) :: {:ok, reply} | {:error, reason}
  @callback post(url, params) :: {:ok, reply} | {:error, reason}
end
