defmodule Mc.Modifier.UrlpTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Urlp

  defmodule Gopher do
    @behaviour Mc.Behaviour.HttpClient
    def get(url), do: {:ok, url}
    def post(url, params), do: {:ok, {url, params}}
  end

  setup do
    start_supervised({Memory, map: %{"big" => "data", "x" => "y\nz"}, name: :mem})
    start_supervised({Get, kv_client: Memory, kv_pid: :mem})
    start_supervised({Urlp, http_client: Gopher})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Urlp.http_client/0" do
    test "returns the HTTP client implementation" do
      assert Urlp.http_client() == Gopher
    end
  end

  describe "Mc.Modifier.Urlp.modify/2" do
    test "builds a keyword list from `args` (pulling values from KV) and delegates to the implementation" do
      assert Urlp.modify("n/a", "127.0.0.1") == {:ok, {"127.0.0.1", []}}
      assert Urlp.modify("", "http://localhost x:big") == {:ok, {"http://localhost", [x: "data"]}}
      assert Urlp.modify("", "url grab:big say:x") == {:ok, {"url", [grab: "data", say: "y\nz"]}}
      assert Urlp.modify("", "url y:noexist") == {:ok, {"url", [y: ""]}}
    end

    test "errors given bad args" do
      assert Urlp.modify("", "") == {:error, "Mc.Modifier.Urlp#modify: parse error"}
      assert Urlp.modify("", "url param-name-only") == {:error, "Mc.Modifier.Urlp#modify: parse error"}
      assert Urlp.modify("", "url :") == {:error, "Mc.Modifier.Urlp#modify: parse error"}
      assert Urlp.modify("", "url foo:") == {:error, "Mc.Modifier.Urlp#modify: parse error"}
      assert Urlp.modify("", "url :bar") == {:error, "Mc.Modifier.Urlp#modify: parse error"}
    end

    test "works with ok tuples" do
      assert Urlp.modify({:ok, "n/a"}, "url db:big") == {:ok, {"url", [db: "data"]}}
    end

    test "allows error tuples to pass through" do
      assert Urlp.modify({:error, "reason"}, "url") == {:error, "reason"}
    end
  end
end
