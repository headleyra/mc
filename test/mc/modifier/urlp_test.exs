defmodule Mc.Modifier.UrlpTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Urlp

  setup do
    map = %{"big" => "data", "x" => "y\nz"}
    start_supervised({KvMemory, map: map, name: :mem})
    start_supervised({Get, kv_pid: :mem})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "modify/2" do
    # To build the 'params keyword list', `args` is interpreted as follows:
    # "a:b c:d" means we require a parameter called 'a' with a value of, the value of `Mc.modify("", "get b")`
    # and ditto for 'c', i.e., 'c' => `Mc.modify("", "get d")`
    test "builds a params keyword list from `args` and calls `post` (on its HTTP adapter) with said params" do
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
