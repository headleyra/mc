defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv
  alias Mc.Modifier.Email
  alias Mc.Modifier.Find
  alias Mc.Modifier.Get
  alias Mc.Modifier.Url
  alias Mc.Modifier.Urlp
  alias Mc.Modifier.Set

  defmodule Postee do
    @behaviour Mc.Behaviour.MailClient
    def deliver(_subject, _message, _recipients), do: {:ok, "sent"}
  end

  defmodule Gopher do
    @behaviour Mc.Behaviour.HttpClient
    def get(_url), do: {:ok, "get"}
    def post(_url, _params), do: {:ok, "post"}
  end

  setup do
    start_supervised({Kv, map: %{}})
    start_supervised({Get, kv_client: Kv})
    start_supervised({Set, kv_client: Kv})
    start_supervised({Find, kv_client: Kv})
    start_supervised({Url, http_client: Gopher})
    start_supervised({Urlp, http_client: Gopher})
    start_supervised({Email, mail_client: Postee})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "%Mc.Mappings{}" do
    test "defines modifiers that exist" do
      %Mc.Mappings{}
      |> Map.from_struct()
      |> Map.keys()
      |> Enum.map(fn key -> Map.get(%Mc.Mappings{}, key) end)
      |> Enum.each(fn {mod, func} -> apply(mod, func, ["", ""]) end)
    end
  end
end
