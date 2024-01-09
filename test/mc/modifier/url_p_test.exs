defmodule Mc.Modifier.UrlPTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.UrlP

  setup do
    map = %{"big" => "data", "x" => "y\nz"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    # To build the 'params keyword list', `args` is interpreted as follows:
    # "a:b c:d" means we require a parameter called 'a' with a value of, the value of
    # `Mc.modify("", "get b", mappings)` and ditto for 'c', i.e., 'c' => `Mc.modify("", "get d", mappings)`

    test "builds a params keyword list from `args` and calls `post` (on its HTTP adapter) with said params" do
      assert UrlP.modify("n/a", "127.0.0.1", %Mc.Mappings{}) == {:ok, {"127.0.0.1", []}}
      assert UrlP.modify("", "http://localhost x:big", %Mc.Mappings{}) == {:ok, {"http://localhost", [x: "data"]}}
      assert UrlP.modify("", "url grab:big say:x", %Mc.Mappings{}) == {:ok, {"url", [grab: "data", say: "y\nz"]}}
      assert UrlP.modify("", "url y:noexist", %Mc.Mappings{}) == {:ok, {"url", [y: ""]}}
    end

    test "errors given bad args" do
      assert UrlP.modify("", "", %Mc.Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url param-name-only", %Mc.Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url :", %Mc.Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url foo:", %Mc.Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url :bar", %Mc.Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
    end

    test "works with ok tuples" do
      assert UrlP.modify({:ok, "n/a"}, "url db:big", %Mc.Mappings{}) == {:ok, {"url", [db: "data"]}}
    end

    test "allows error tuples to pass through" do
      assert UrlP.modify({:error, "reason"}, "url", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
