defmodule Mc.X do
  def startup do
    {:ok, kv} = Mc.Modifier.Kv.start_link(%{})
    {:ok, web} = Mc.Modifier.Web.start_link(Mc.Util.WebClient)
    {:ok, email} = Mc.Modifier.Email.start_link(Mc.Util.Mailgun)
    {:ok, mc} = Mc.start_link(%Mc.Mappings{})

    %{kv: kv, web: web, email: email, mc: mc}
  end
end
