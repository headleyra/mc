defmodule Mc.Modifier.HttpTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.{Kv, Http}

  defmodule Gopher do
    @behaviour Mc.Behaviour.HttpClient
    def get(url), do: {:ok, url}
    def post(url, params), do: {:ok, {url, params}}
  end

  setup do
    start_supervised({Kv, map: %{"data" => "big data", "payload" => "testing\n123"}})
    start_supervised({Http, http_client: Gopher})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Http.http_client/0" do
    test "returns the HTTP behaviour implementation" do
      assert Http.http_client() == Gopher
    end
  end

  describe "Mc.Modifier.Http.get/2" do
    test "delegates to the behaviour implementation" do
      assert Http.get("n/a", "http://example.org") == {:ok, "http://example.org"}
    end

    test "works with ok tuples" do
      assert Http.get({:ok, "n/a"}, "localhost:4000") == {:ok, "localhost:4000"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Http.get({:error, "reason"}, "url") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Http.post/2" do
    test "builds a keyword list from `args` (pulling values from KV) and delegates to the behaviour implementation" do
      assert Http.post("n/a", "127.0.0.1") == {:ok, {"127.0.0.1", []}}
      assert Http.post("", "http://localhost x:data") == {:ok, {"http://localhost", [x: "big data"]}}
      assert Http.post("", "url grab:data say:payload") == {:ok, {"url", [grab: "big data", say: "testing\n123"]}}
      assert Http.post("", "url y:noexist") == {:ok, {"url", [y: ""]}}
    end

    test "returns an error tuple (given bad args)" do
      assert Http.post("n/a", "") == {:error, "http (POST): bad args"}
      assert Http.post("", "url param-name-only") == {:error, "http (POST): bad args"}
      assert Http.post("", "url :") == {:error, "http (POST): bad args"}
      assert Http.post("", "url foo:") == {:error, "http (POST): bad args"}
      assert Http.post("", "url :bar") == {:error, "http (POST): bad args"}
    end

    test "works with ok tuples" do
      assert Http.post({:ok, "n/a"}, "url db:data") == {:ok, {"url", [db: "big data"]}}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Http.post({:error, "reason"}, "url") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Http.build_params/1" do
    test "build a keyword list given a string containing colon separated param-name/kv-key pairs" do
      assert Http.build_params("param_name_1:data") == [param_name_1: "big data"]
      assert Http.build_params("p1:data p2:payload") == [p1: "big data", p2: "testing\n123"]
      assert Http.build_params("x:data\t \t  y:payload") == [x: "big data", y: "testing\n123"]
      assert Http.build_params("one:data two:no-exist") == [one: "big data", two: ""]
      assert Http.build_params("") == []
    end

    test "returns :error for malformed params" do
      assert Http.build_params("param-name-only") == :error
      assert Http.build_params(":") == :error
      assert Http.build_params(":11pm") == :error
      assert Http.build_params("delta:") == :error
    end
  end

  describe "Mc.Modifier.Http.build_url_params/1" do
    test "returns a 'URL/params' list" do
      assert Http.build_url_params("example.com") == ["example.com", []]
      assert Http.build_url_params("url p1:data") == ["url", [p1: "big data"]]
      assert Http.build_url_params("url x:data y:payload") == ["url", [x: "big data", y: "testing\n123"]]
    end

    test "returns :error malformed input" do
      assert Http.build_url_params("") == :error
      assert Http.build_url_params("example.com :") == :error
      assert Http.build_url_params("url :nope") == :error
      assert Http.build_url_params("url yeah:") == :error
    end
  end
end
