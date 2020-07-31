defmodule Mc.Modifier.WebTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.{Kv, Web}

  defmodule Gopher do
    use Mc.WebClientInterface
  end

  setup do
    start_supervised({Kv, %{
      "data" => "big data",
      "payload" => "testing\n123"
    }})
    start_supervised({Web, Gopher})
    start_supervised({Mc, %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Web.web_client_impl_module/0" do
    test "returns the web client implementation module" do
      assert Web.web_client_impl_module() == Gopher
    end
  end

  describe "Mc.Modifier.Web.get/2" do
    test "delegates to the configured module" do
      assert Web.get("n/a", "http://example.org") == {"http://example.org"}
    end

    test "works with ok tuples" do
      assert Web.get({:ok, "n/a"}, "localhost:4000") == {"localhost:4000"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Web.get({:error, "reason"}, "url") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Web.post/2" do
    test "builds params from the buffer and delegates to the configured module" do
      assert Web.post("n/a", "localhost") == {"localhost", %{}}
      assert Web.post("", "url x:data") == {"url", %{x: "big data"}}
      assert Web.post("", "url grab:data say:payload") == {"url", %{grab: "big data", say: "testing\n123"}}
      assert Web.post("", "url y:noexist") == {"url", %{y: ""}}
    end

    test "returns an error tuple with bad args" do
      assert Web.post("n/a", "") == {:error, "Web (POST): bad args"}
      assert Web.post("", "url param-name-only") == {:error, "Web (POST): bad args"}
      assert Web.post("", "url :") == {:error, "Web (POST): bad args"}
      assert Web.post("", "url foo:") == {:error, "Web (POST): bad args"}
      assert Web.post("", "url :bar") == {:error, "Web (POST): bad args"}
    end

    test "works with ok tuples" do
      assert Web.post({:ok, "n/a"}, "url db:data") == {"url", %{db: "big data"}}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Web.post({:error, "reason"}, "url") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Web.build_params/1" do
    test "build a params map given a string containing colon separated param-name/kv-key pairs" do
      assert Web.build_params("param_name_1:data") == %{param_name_1: "big data"}
      assert Web.build_params("p1:data p2:payload") == %{p1: "big data", p2: "testing\n123"}
      assert Web.build_params("x:data\t \t  y:payload") == %{x: "big data", y: "testing\n123"}
      assert Web.build_params("one:data two:no-exist") == %{one: "big data", two: ""}
      assert Web.build_params("") == %{}
    end

    test "returns :error for malformed params" do
      assert Web.build_params("param-name-only") == :error
      assert Web.build_params(":") == :error
      assert Web.build_params(":11pm") == :error
      assert Web.build_params("delta:") == :error
    end
  end

  describe "Mc.Modifier.Web.build_url_params/1" do
    test "returns a 'URL/params' list" do
      assert Web.build_url_params("example.com") == ["example.com", %{}]
      assert Web.build_url_params("url p1:data") == ["url", %{p1: "big data"}]
      assert Web.build_url_params("url x:data y:payload") == ["url", %{x: "big data", y: "testing\n123"}]
    end

    test "returns :error malformed input" do
      assert Web.build_url_params("") == :error
      assert Web.build_url_params("example.com :") == :error
      assert Web.build_url_params("url :nope") == :error
      assert Web.build_url_params("url yeah:") == :error
    end
  end
end
