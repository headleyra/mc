defmodule Mc.Modifier.PrependkTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Prependk

  setup do
    map = %{"star" => "light", "thing" => "ready"}
    start_supervised({KvMemory, map: map})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "modify/2" do
    test "prepends the 'value' associated with the 'key' to the `buffer`" do
      assert Prependk.modify(" steady go!", "thing") == {:ok, "ready steady go!"}
      assert Prependk.modify(" switch", "star") == {:ok, "light switch"}
      assert Prependk.modify("same same", "") == {:ok, "same same"}
    end

    test "works with ok tuples" do
      assert Prependk.modify({:ok, " beam"}, "star") == {:ok, "light beam"}
    end

    test "allows error tuples to pass through" do
      assert Prependk.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
