defmodule Mc.Adapter.Mailgun do
  @behaviour Mc.Behaviour.EmailAdapter

  @impl true
  def deliver(subject, message, recipients) do
    params = [
      from: "#{mailgun_from()}@#{mailgun_domain()}",
      to: recipients,
      subject: subject,
      text: message
    ]

    Mc.Adapter.Http.post(mailgun_url(), params)
    {:ok, message}
  end

  defp mailgun_api_key do
    System.get_env("MAILGUN_API_KEY")
  end

  defp mailgun_api_version do
    System.get_env("MAILGUN_API_VERSION")
  end

  defp mailgun_from do
    System.get_env("MAILGUN_FROM")
  end

  defp mailgun_domain do
    System.get_env("MAILGUN_DOMAIN")
  end

  defp mailgun_url do
    "https://api:#{mailgun_api_key()}@api.mailgun.net/#{mailgun_api_version()}/#{mailgun_domain()}/messages"
  end
end
