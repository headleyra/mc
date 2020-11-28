defmodule Mc.Behaviour.Mailer do
  @type subject :: String.t
  @type message :: String.t
  @type email :: String.t
  @type recipients :: [email]
  @type reply :: term
  @type reason :: String.t

  @callback deliver(subject, message, recipients) :: {:ok, reply} | {:error, reason}
end
