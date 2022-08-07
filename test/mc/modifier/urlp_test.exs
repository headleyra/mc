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
    start_supervised({Memory, map: %{"big" => "data", "x" => "y\nz"}})
    start_supervised({Get, kv_client: Memory})
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

    test "returns a help message" do
      assert Check.has_help?(Urlp, :modify)
    end

    test "errors with unknown switches" do
      assert Urlp.modify("", "--unknown") == {:error, "Mc.Modifier.Urlp#modify: switch parse error"}
      assert Urlp.modify("", "-u") == {:error, "Mc.Modifier.Urlp#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Urlp.modify({:ok, "n/a"}, "url db:big") == {:ok, {"url", [db: "data"]}}
    end

    test "allows error tuples to pass through" do
      assert Urlp.modify({:error, "reason"}, "url") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Urlp.build_url_with_params/1" do
    test "returns a 'URL/params' list" do
      assert Urlp.build_url_with_params("example.com") == {:ok, ["example.com", []]}
      assert Urlp.build_url_with_params("url p1:big") == {:ok, ["url", [p1: "data"]]}
      assert Urlp.build_url_with_params("url x:big y:x") == {:ok, ["url", [x: "data", y: "y\nz"]]}
    end

    test "errors with bad or missing URL/params" do
      assert Urlp.build_url_with_params("") == :error
      assert Urlp.build_url_with_params("    ") == :error
      assert Urlp.build_url_with_params("example.com :") == :error
      assert Urlp.build_url_with_params("url :nope") == :error
      assert Urlp.build_url_with_params("url yeah:") == :error
    end
  end

  describe "Mc.Modifier.Urlp.build_params_list/1" do
    test "build a keyword list given a string containing colon separated param-name/kv-key pairs" do
      assert Urlp.build_params_list("param_name_1:big") == {:ok, [param_name_1: "data"]}
      assert Urlp.build_params_list("p1:big p2:x") == {:ok, [p1: "data", p2: "y\nz"]}
      assert Urlp.build_params_list("x:big\t \t  y:x") == {:ok, [x: "data", y: "y\nz"]}
      assert Urlp.build_params_list("one:big two:no-exist") == {:ok, [one: "data", two: ""]}
      assert Urlp.build_params_list("") == {:ok, []}
    end

    test "errors with bad params" do
      assert Urlp.build_params_list("param-name-only") == :error
      assert Urlp.build_params_list(":") == :error
      assert Urlp.build_params_list(":11pm") == :error
      assert Urlp.build_params_list("delta:") == :error
    end
  end
end
