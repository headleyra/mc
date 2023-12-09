defmodule Mc.Modifier.UrlTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Url

  describe "modify/3" do
    test "calls `get` on its HTTP adapter" do
      assert Url.modify("n/a", "http://example.org", %{}) == {:ok, "http://example.org"}
      assert Url.modify("", "http://example.net", %{}) == {:ok, "http://example.net"}
    end

    test "works with ok tuples" do
      assert Url.modify({:ok, "n/a"}, "localhost:4000", %{}) == {:ok, "localhost:4000"}
    end

    test "allows error tuples to pass through" do
      assert Url.modify({:error, "reason"}, "url", %{}) == {:error, "reason"}
    end
  end
end
