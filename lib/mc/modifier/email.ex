defmodule Mc.Modifier.Email do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        recipient_list = String.split(recipients)
        apply(mail_adapter(), :deliver, [subject, buffer, recipient_list])

      _bad_args ->
        oops(:modify, "missing subject and/or recipients")
    end
  end

  defp mail_adapter do
    Application.get_env(:mc, :mail_adapter)
  end
end
