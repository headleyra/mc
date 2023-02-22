import Config

config :mc, :kv_adapter, Mc.Adapter.KvMemory
config :mc, :http_adapter, Mc.Test.HttpAdapter
config :mc, :mail_adapter, Mc.Test.MailAdapter
