ExUnit.start()

defmodule Gopher do
  @behaviour Mc.Behaviour.HttpClient
  def get(url), do: {:ok, url}
  def post(url, params), do: {:ok, {url, params}}
end

defmodule Postee do
  @behaviour Mc.Behaviour.Mailer
  def deliver(subject, message, recipients), do: {:ok, {subject, message, recipients}}
end

# Mc.Modifier.Kv.start_link(map: %{})
Mc.Modifier.Http.start_link(http_client: Gopher)
Mc.Modifier.Email.start_link(mailer: Postee)
Mc.start_link(mappings: %Mc.Mappings{})
