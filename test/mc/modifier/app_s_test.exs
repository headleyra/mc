defmodule Mc.Modifier.AppSTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppS

  setup do
    map = %{
      "app1" => "casel",
      "app2" => "replace x ::1\nreplace y ::2",
      "app3" => "replace y ::2",
      "app4" => "buffer all: :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "gets an 'app script' using an 'app key' (`args`)", %{mappings: mappings} do
      assert AppS.m("n/a", "app1", mappings) == {:ok, "casel"}
      assert AppS.m("", "app2", mappings) == {:ok, "replace x ::1\nreplace y ::2"}
      assert AppS.m("", "app3", mappings) == {:ok, "replace y ::2"}
      assert AppS.m("", "app4", mappings) == {:ok, "buffer all: :::"}
    end

    test "assigns arguments to placeholders (::1, ::2, ...)", %{mappings: mappings} do
      assert AppS.m("n/a", "app2 arg1 arg2", mappings) == {:ok, "replace x arg1\nreplace y arg2"}
      assert AppS.m("", "app3 ignored cash", mappings) == {:ok, "replace y cash"}
      assert AppS.m("", "app1 no.replacements.in.this.app", mappings) == {:ok, "casel"}
    end

    test "replaces the 'all args' placeholder (:::)", %{mappings: mappings} do
      assert AppS.m("", "app4 uno dos", mappings) == {:ok, "buffer all: uno dos"}
    end

    test "errors when the 'app key' doesn't exist", %{mappings: mappings} do
      assert AppS.m("n/a", "oops", mappings) == {:error, Mc.Modifier.AppS, :not_found, "oops", []}
      assert AppS.m("", "nah", mappings) == {:error, Mc.Modifier.AppS, :not_found, "nah", []}
      assert AppS.m("", "no-exist", mappings) == {:error, Mc.Modifier.AppS, :not_found, "no-exist", []}
    end

    test "errors when the 'app key' is missing", %{mappings: mappings} do
      assert AppS.m("n/a", "", mappings) == {:error, Mc.Modifier.AppS, :missing_app_key, nil, []}
      assert AppS.m("", "  ", mappings) == {:error, Mc.Modifier.AppS, :missing_app_key, nil, []}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert AppS.m("", "app1", mappings) == {:ok, "casel"}
    end

    test "allows error-tuples to pass through" do
      assert AppS.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
