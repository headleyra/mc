defmodule Mc.Behaviour.MailAdapter do
  @type subject :: String.t
  @type message :: String.t
  @type email :: String.t
  @type recipients :: [email]
  @type reply :: String.t
  @type reason :: String.t

  @callback deliver(subject, message, recipients) :: {:ok, reply} | {:error, reason}
end
