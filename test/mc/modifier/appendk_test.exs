defmodule Mc.Modifier.AppendkTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Appendk

  setup do
    map = %{"star" => "light", "thing" => "bar"}
    start_supervised({KvMemory, map: map})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "modify/2" do
    test "parses `args` as a 'key' and appends its value to the `buffer`" do
      assert Appendk.modify("raise the ", "thing") == {:ok, "raise the bar"}
      assert Appendk.modify("same", "key.no.exist") == {:ok, "same"}
      assert Appendk.modify("same", "") == {:ok, "same"}
    end

    test "works with ok tuples" do
      assert Appendk.modify({:ok, "bright "}, "star") == {:ok, "bright light"}
    end

    test "allows error tuples to pass through" do
      assert Appendk.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
