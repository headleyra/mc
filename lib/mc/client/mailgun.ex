defmodule Mc.Client.Mailgun do
  @behaviour Mc.Behaviour.MailClient

  @impl true
  def deliver(subject, message, recipients) do
    params = [
      from: "#{mailgun_from()}@#{mailgun_domain()}",
      to: recipients,
      subject: subject,
      text: message
    ]

    apply(Mc.Client.Http, :post, [mailgun_url(), params])
    {:ok, message}
  end

  def mailgun_api_key do
    System.get_env("MAILGUN_API_KEY")
  end

  def mailgun_api_version do
    System.get_env("MAILGUN_API_VERSION")
  end

  def mailgun_from do
    System.get_env("MAILGUN_FROM")
  end

  def mailgun_domain do
    System.get_env("MAILGUN_DOMAIN")
  end

  def mailgun_url do
    "https://api:#{mailgun_api_key()}@api.mailgun.net/#{mailgun_api_version()}/#{mailgun_domain()}/messages"
  end
end
