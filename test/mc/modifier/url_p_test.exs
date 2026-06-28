defmodule Mc.Modifier.UrlPTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.UrlP

  setup do
    map = %{"big" => "data", "x" => "y\nz"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    params_list = """
    interprets `args` as a 'params list' as follows:
    "a:b c:d" means we require a parameter called 'a' with a value of, the value of
    `Mc.m("", "get b", mappings)` and ditto for 'c', i.e., 'c' => `Mc.m("", "get d", mappings)`
    """

    test params_list, do: true

    test "builds a 'params list' and calls `post` on its HTTP adapter", %{mappings: mappings} do
      assert UrlP.m("n/a", "127.0.0.1", mappings) == {:ok, {"127.0.0.1", []}}
      assert UrlP.m("", "http://localhost x:big", mappings) == {:ok, {"http://localhost", [x: "data"]}}
      assert UrlP.m("", "url grab:big say:x", mappings) == {:ok, {"url", [grab: "data", say: "y\nz"]}}
      assert UrlP.m("", "url y:noexist", mappings) == {:ok, {"url", [y: ""]}}
    end

    test "errors given a bad 'params list'", %{mappings: mappings} do
      assert UrlP.m("", "", mappings) == {:error, Mc.Modifier.UrlP, :bad_params_list, "", []}
      assert UrlP.m("", "url param-name-only", mappings) == {:error, Mc.Modifier.UrlP, :bad_params_list, "url param-name-only", []}
      assert UrlP.m("", "url :", mappings) == {:error, Mc.Modifier.UrlP, :bad_params_list, "url :", []}
      assert UrlP.m("", "url foo:", mappings) == {:error, Mc.Modifier.UrlP, :bad_params_list, "url foo:", []}
      assert UrlP.m("", "url :bar", mappings) == {:error, Mc.Modifier.UrlP, :bad_params_list, "url :bar", []}
    end

    test "wraps errors returned from the HTTP adapter" do
      assert UrlP.m("", "trigger-error", %{}) == {:error, Mc.Modifier.UrlP, :adapter_error, nil, []}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert UrlP.m({:ok, "n/a"}, "url db:big", mappings) == {:ok, {"url", [db: "data"]}}
    end

    test "allows error-tuples to pass through" do
      assert UrlP.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
