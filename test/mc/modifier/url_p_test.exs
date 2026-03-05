defmodule Mc.Modifier.UrlPTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.UrlP

  setup do
    map = %{"big" => "data", "x" => "y\nz"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    # To build the 'params keyword list', `args` is interpreted as follows:
    # "a:b c:d" means we require a parameter called 'a' with a value of, the value of
    # `Mc.m("", "get b", mappings)` and ditto for 'c', i.e., 'c' => `Mc.m("", "get d", mappings)`

    test "builds a params keyword list; calls `post` (on HTTP adapter)", %{mappings: mappings} do
      assert UrlP.m("n/a", "127.0.0.1", mappings) == {:ok, {"127.0.0.1", []}}
      assert UrlP.m("", "http://localhost x:big", mappings) == {:ok, {"http://localhost", [x: "data"]}}
      assert UrlP.m("", "url grab:big say:x", mappings) == {:ok, {"url", [grab: "data", say: "y\nz"]}}
      assert UrlP.m("", "url y:noexist", mappings) == {:ok, {"url", [y: ""]}}
    end

    test "errors given bad args", %{mappings: mappings} do
      assert UrlP.m("", "", mappings) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.m("", "url param-name-only", mappings) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.m("", "url :", mappings) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.m("", "url foo:", mappings) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.m("", "url :bar", mappings) == {:error, "Mc.Modifier.UrlP: parse error"}
    end

    test "wraps errors returned from the HTTP adapter" do
      assert UrlP.m("", "trigger-error", %{}) == {:error, "Mc.Modifier.UrlP: POST error"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert UrlP.m({:ok, "n/a"}, "url db:big", mappings) == {:ok, {"url", [db: "data"]}}
    end

    test "allows error tuples to pass through", %{mappings: mappings}do
      assert UrlP.m({:error, "reason"}, "url", mappings) == {:error, "reason"}
    end
  end
end
