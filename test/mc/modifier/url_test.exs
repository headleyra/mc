defmodule Mc.Modifier.UrlTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Url

  describe "m/3" do
    test "calls `get` on its HTTP adapter" do
      assert Url.m("n/a", "http://example.org", %{}) == {:ok, "http://example.org"}
      assert Url.m("", "http://example.net", %{}) == {:ok, "http://example.net"}
    end

    test "wraps errors returned from the HTTP adapter" do
      assert Url.m("", "trigger-error", %{}) == {:error, "Mc.Modifier.Url: GET error"}
    end

    test "works with ok tuples" do
      assert Url.m({:ok, "n/a"}, "localhost:4000", %{}) == {:ok, "localhost:4000"}
    end

    test "allows error tuples to pass through" do
      assert Url.m({:error, "reason"}, "url", %{}) == {:error, "reason"}
    end
  end
end
