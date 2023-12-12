defmodule Mc.Modifier.AppendkTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Appendk

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"star" => "light", "thing" => "bar"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a 'key' and appends its value to the `buffer`" do
      assert Appendk.modify("raise the ", "thing", %Mappings{}) == {:ok, "raise the bar"}
      assert Appendk.modify("same", "key.no.exist", %Mappings{}) == {:ok, "same"}
      assert Appendk.modify("same", "", %Mappings{}) == {:ok, "same"}
    end

    test "works with ok tuples" do
      assert Appendk.modify({:ok, "bright "}, "star", %Mappings{}) == {:ok, "bright light"}
    end

    test "allows error tuples to pass through" do
      assert Appendk.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
