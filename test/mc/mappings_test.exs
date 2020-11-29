defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false

  defmodule Gopher do
    @behaviour Mc.Behaviour.HttpClient
    def get(_url), do: {:ok, "get"}
    def post(_url, _params), do: {:ok, "post"}
  end

  defmodule Postee do
    @behaviour Mc.Behaviour.Mailer
    def deliver(_subject, _message, _recipients), do: {:ok, "deliver"}
  end

  setup do
    start_supervised({Mc.Modifier.Http, Gopher})
    start_supervised({Mc.Modifier.Email, Postee})
    start_supervised({Mc, %Mc.Mappings{}})
    start_supervised({Mc.Modifier.Kv, %{}})
    :ok
  end

  describe "%Mc.Mappings{}" do
    test "defines modifiers that exist" do
      %Mc.Mappings{}
      |> Map.keys()
      |> Enum.reject(fn key -> key == :__struct__ end)
      |> Enum.map(fn key -> Map.get(%Mc.Mappings{}, key) end)
      |> Enum.each(fn {mod, func} -> apply(mod, func, ["", ""]) end)
    end
  end
end
