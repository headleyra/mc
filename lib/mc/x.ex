defmodule Mc.X do
  def defaults_start do
    {:ok, kv} = Mc.Modifier.Kv.start_link(%{})
    {:ok, web} = Mc.Modifier.Web.start_link(Mc.Util.WebClient)
    {:ok, email} = Mc.Modifier.Email.start_link(Mc.Util.Mailgun)
    {:ok, mc} = Mc.start_link(%Mc.Mappings{})

    %{kv: kv, web: web, email: email, mc: mc}
  end

  def mongo_start(mongodb_uri: mongodb_uri, mongodb_collection: mongodb_collection) do
    {:ok, mongo} = Mongo.start_link(url: mongodb_uri, name: :mongo)
    {:ok, kvp} = Mc.X.Mongokv.start_link(mongodb_collection)

    %{mongo: mongo, kvp: kvp}
  end
end
