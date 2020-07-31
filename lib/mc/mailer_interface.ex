defmodule Mc.MailerInterface do
  defmacro __using__(_) do
    quote do
      def deliver(subject, message, recipient_list) do
        {subject, message, recipient_list}
      end

      defoverridable deliver: 3
    end
  end
end
