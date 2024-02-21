defmodule Mc.Modifier.AppSTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppS

  setup do
    map = %{
      "app1" => "casel",
      "app3" => "r a ::1\nr b ::2",
      "app5" => "r b ::2",
      "app7" => "b 1 => ::1, 2 => ::2, all => :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "builds an 'app script' given an 'app key'" do
      assert AppS.modify("n/a", "app1", %Mc.Mappings{}) == {:ok, "casel"}
      assert AppS.modify("", "app3", %Mc.Mappings{}) == {:ok, "r a ::1\nr b ::2"}
      assert AppS.modify("", "app5", %Mc.Mappings{}) == {:ok, "r b ::2"}
      assert AppS.modify("", "app7", %Mc.Mappings{}) == {:ok, "b 1 => ::1, 2 => ::2, all => :::"}
    end

    test "errors when the app doesn't exist" do
      assert AppS.modify("stuff", "", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: app not found"}
      assert AppS.modify("", "", %Mc.Mappings{}) == {:error, "Mc.Modifier.AppS: app not found"}
    end

    test "replaces placeholders (::1 => arg1, ::2 => arg2, ...)" do
      assert AppS.modify("", "app3 arg1 arg2", %Mc.Mappings{}) == {:ok, "r a arg1\nr b arg2"}
      assert AppS.modify("", "app5 ignored cash", %Mc.Mappings{}) == {:ok, "r b cash"}
      assert AppS.modify("", "app1 no.replacements.in.this.app", %Mc.Mappings{}) == {:ok, "casel"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)" do
      assert AppS.modify("", "app7 uno dos", %Mc.Mappings{}) == {:ok, "b 1 => uno, 2 => dos, all => uno dos"}
    end

    test "works with ok tuples" do
      assert AppS.modify("", "app1", %Mc.Mappings{}) == {:ok, "casel"}
    end

    test "allows error tuples to pass through" do
      assert AppS.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
