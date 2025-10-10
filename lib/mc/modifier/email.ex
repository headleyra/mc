defmodule Mc.Modifier.Email do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        email(buffer, subject, recipients)

      _bad_args ->
        oops("missing subject/recipients")
    end
  end

  defp email(message, subject, recipients) do
    recipient_list = String.split(recipients)

    case adapter().deliver(subject, message, recipient_list) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason} ->
        oops(reason)
    end
  end

  defp adapter do
    Application.get_env(:mc, :mail_adapter)
  end
end
