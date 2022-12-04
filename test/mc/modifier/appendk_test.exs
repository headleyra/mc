defmodule Mc.Modifier.AppendkTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Appendk

  setup do
    start_supervised({Memory, map: %{"star" => "light", "thing" => "bar"}, name: :dosh})
    start_supervised({Get, kv_client: Memory, kv_pid: :dosh})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Appendk.modify/2" do
    test "parses `args` as a 'key' and appends its value to the `buffer`" do
      assert Appendk.modify("raise the ", "thing") == {:ok, "raise the bar"}
      assert Appendk.modify("same same", "no.exist") == {:ok, "same same"}
    end

    test "works with ok tuples" do
      assert Appendk.modify({:ok, "bright "}, "star") == {:ok, "bright light"}
    end

    test "allows error tuples to pass through" do
      assert Appendk.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
