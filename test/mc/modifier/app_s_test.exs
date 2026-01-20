defmodule Mc.Modifier.AppSTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppS

  setup do
    map = %{
      "app1" => "casel",
      "app3" => "r a ::1\nr b ::2",
      "app5" => "r b ::2",
      "app7" => "b all: :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "gets an 'app script' using an app key", %{mappings: mappings} do
      assert AppS.modify("n/a", "app1", mappings) == {:ok, "casel"}
      assert AppS.modify("", "app3", mappings) == {:ok, "r a ::1\nr b ::2"}
      assert AppS.modify("", "app5", mappings) == {:ok, "r b ::2"}
      assert AppS.modify("", "app7", mappings) == {:ok, "b all: :::"}
    end

    test "errors when the app doesn't exist", %{mappings: mappings} do
      assert AppS.modify("n/a", "oops", mappings) == {:error, "Mc.Modifier.AppS: not found: oops"}
      assert AppS.modify("", "nah", mappings) == {:error, "Mc.Modifier.AppS: not found: nah"}
    end

    test "assigns arguments to placeholders (::1, ::2, ...)", %{mappings: mappings} do
      assert AppS.modify("n/a", "app3 arg1 arg2", mappings) == {:ok, "r a arg1\nr b arg2"}
      assert AppS.modify("", "app5 ignored cash", mappings) == {:ok, "r b cash"}
      assert AppS.modify("", "app1 no.replacements.in.this.app", mappings) == {:ok, "casel"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)", %{mappings: mappings} do
      assert AppS.modify("", "app7 uno dos", mappings) == {:ok, "b all: uno dos"}
    end

    test "errors when the app doesn't exist and arguments are passed", %{mappings: mappings} do
      assert AppS.modify("n/a", "oops", mappings) == {:error, "Mc.Modifier.AppS: not found: oops"}
      assert AppS.modify("", "nah arg1", mappings) == {:error, "Mc.Modifier.AppS: not found: nah"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert AppS.modify("", "app1", mappings) == {:ok, "casel"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert AppS.modify({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
