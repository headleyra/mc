defmodule Mc.Modifier.UrlPTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.UrlP

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"big" => "data", "x" => "y\nz"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    # To build the 'params keyword list', `args` is interpreted as follows:
    # "a:b c:d" means we require a parameter called 'a' with a value of, the value of
    # `Mc.modify("", "get b", mappings)` and ditto for 'c', i.e., 'c' => `Mc.modify("", "get d", mappings)`

    test "builds a params keyword list from `args` and calls `post` (on its HTTP adapter) with said params" do
      assert UrlP.modify("n/a", "127.0.0.1", %Mappings{}) == {:ok, {"127.0.0.1", []}}
      assert UrlP.modify("", "http://localhost x:big", %Mappings{}) == {:ok, {"http://localhost", [x: "data"]}}
      assert UrlP.modify("", "url grab:big say:x", %Mappings{}) == {:ok, {"url", [grab: "data", say: "y\nz"]}}
      assert UrlP.modify("", "url y:noexist", %Mappings{}) == {:ok, {"url", [y: ""]}}
    end

    test "errors given bad args" do
      assert UrlP.modify("", "", %Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url param-name-only", %Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url :", %Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url foo:", %Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
      assert UrlP.modify("", "url :bar", %Mappings{}) == {:error, "Mc.Modifier.UrlP: parse error"}
    end

    test "works with ok tuples" do
      assert UrlP.modify({:ok, "n/a"}, "url db:big", %Mappings{}) == {:ok, {"url", [db: "data"]}}
    end

    test "allows error tuples to pass through" do
      assert UrlP.modify({:error, "reason"}, "url", %Mappings{}) == {:error, "reason"}
    end
  end
end
