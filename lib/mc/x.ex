defmodule Mc.X do
  def startup do
    {:ok, kv} = Mc.Modifier.Kv.start_link(map: %{})
    {:ok, web} = Mc.Modifier.Http.start_link(http_client: Mc.Client.Http)
    {:ok, email} = Mc.Modifier.Email.start_link(mailer: Mc.Client.Mailgun)
    {:ok, mc} = Mc.start_link(mappings: %Mc.Mappings{})

    %{kv: kv, web: web, email: email, mc: mc}
  end
end
