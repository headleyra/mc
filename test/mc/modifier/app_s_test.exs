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
    :ok
  end

  describe "modify/3" do
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "gets an 'app script' using an app key" do
      assert AppS.modify("n/a", "app1", %Mc.Mappings{}) == {:ok, "casel"}
      assert AppS.modify("", "app3", %Mc.Mappings{}) == {:ok, "r a ::1\nr b ::2"}
      assert AppS.modify("", "app5", %Mc.Mappings{}) == {:ok, "r b ::2"}
      assert AppS.modify("", "app7", %Mc.Mappings{}) == {:ok, "b all: :::"}
    end

    test "errors when the app doesn't exist" do
      assert AppS.modify("n/a", "oops", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: not found: oops"}
      assert AppS.modify("", "nah", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: not found: nah"}
    end

    test "assigns arguments to placeholders (::1, ::2, ...)" do
      assert AppS.modify("n/a", "app3 arg1 arg2", %Mc.Mappings{}) == {:ok, "r a arg1\nr b arg2"}
      assert AppS.modify("", "app5 ignored cash", %Mc.Mappings{}) == {:ok, "r b cash"}
      assert AppS.modify("", "app1 no.replacements.in.this.app", %Mc.Mappings{}) == {:ok, "casel"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)" do
      assert AppS.modify("", "app7 uno dos", %Mc.Mappings{}) == {:ok, "b all: uno dos"}
    end

    test "errors when the app doesn't exist and arguments are passed" do
      assert AppS.modify("n/a", "oops", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: not found: oops"}
      assert AppS.modify("", "nah arg1", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: not found: nah"}
    end

    test "works with ok tuples" do
      assert AppS.modify("", "app1", %Mc.Mappings{}) == {:ok, "casel"}
    end

    test "allows error tuples to pass through" do
      assert AppS.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
