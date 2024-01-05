defmodule Mc.Modifier.AppsTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.Apps

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{
      "app1" => "script1",
      "app3" => "script3\nscript5",
      "app5" => "script3",
      "app7" => "script7",
      "script1" => "lcase",
      "script3" => "r a ::1",
      "script5" => "r b ::2",
      "script7" => "b 1 => ::1, 2 => ::2, all => :::"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "builds an 'app script' given an 'app key'" do
      assert Apps.modify("n/a", "app1", %Mappings{}) == {:ok, "lcase"}
      assert Apps.modify("", "app3", %Mappings{}) == {:ok, "r a ::1\nr b ::2"}
      assert Apps.modify("", "app5", %Mappings{}) == {:ok, "r a ::1"}
      assert Apps.modify("", "app7", %Mappings{}) == {:ok, "b 1 => ::1, 2 => ::2, all => :::"}
      assert Apps.modify("stuff", "", %Mappings{}) == {:ok, ""}
      assert Apps.modify("", "", %Mappings{}) == {:ok, ""}
    end

    test "replaces placeholders (::1 => arg1, ::2 => arg2, ...)" do
      assert Apps.modify("", "app3 arg1 arg2", %Mappings{}) == {:ok, "r a arg1\nr b arg2"}
      assert Apps.modify("", "app5 cash", %Mappings{}) == {:ok, "r a cash"}
      assert Apps.modify("", "app1 no.replacements.in.this.app", %Mappings{}) == {:ok, "lcase"}
    end

    test "replaces the 'all args' placeholder (::: => arg*)" do
      assert Apps.modify("", "app7 uno dos", %Mappings{}) == {:ok, "b 1 => uno, 2 => dos, all => uno dos"}
    end

    test "works with ok tuples" do
      assert Apps.modify("", "app1", %Mappings{}) == {:ok, "lcase"}
    end

    test "allows error tuples to pass through" do
      assert Apps.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
