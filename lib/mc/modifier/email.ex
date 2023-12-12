defmodule Mc.Modifier.Email do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case String.split(args, ", ", parts: 2) do
      [subject, recipients] ->
        recipient_list = String.split(recipients)
        adapter().deliver(subject, buffer, recipient_list)

      _bad_args ->
        oops("missing subject and/or recipients")
    end
  end

  defp adapter do
    Application.get_env(:mc, :mail_adapter)
  end
end
