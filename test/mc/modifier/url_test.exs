defmodule Mc.Modifier.UrlTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Url

  defmodule Gopher do
    @behaviour Mc.Behaviour.HttpClient
    def get(url), do: {:ok, url}
    def post(_url, _params), do: :not_used
  end

  setup do
    start_supervised({Url, http_client: Gopher})
    :ok
  end

  describe "Mc.Modifier.Url.http_client/0" do
    test "returns the HTTP client implementation" do
      assert Url.http_client() == Gopher
    end
  end

  describe "Mc.Modifier.Url.modify/2" do
    test "delegates to the HTTP client implementation" do
      assert Url.modify("", "http://example.net") == {:ok, "http://example.net"}
      assert Url.modify("n/a", "http://two.example.org") == {:ok, "http://two.example.org"}
    end

    test "returns a help message" do
      assert Check.has_help?(Url, :modify)
    end

    test "errors with unknown switches" do
      assert Url.modify("", "--unknown") == {:error, "Mc.Modifier.Url#modify: switch parse error"}
      assert Url.modify("", "-u") == {:error, "Mc.Modifier.Url#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Url.modify({:ok, "n/a"}, "localhost:4000") == {:ok, "localhost:4000"}
    end

    test "allows error tuples to pass through" do
      assert Url.modify({:error, "reason"}, "url") == {:error, "reason"}
    end
  end
end
