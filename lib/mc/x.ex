defmodule Mc.X do
  def startup do
    {:ok, kv} = Mc.Modifier.Kv.start_link(%{})
    {:ok, web} = Mc.Modifier.Http.start_link(Mc.Client.Http)
    {:ok, email} = Mc.Modifier.Email.start_link(Mc.Client.Mailgun)
    {:ok, mc} = Mc.start_link(%Mc.Mappings{})

    %{kv: kv, web: web, email: email, mc: mc}
  end
end
