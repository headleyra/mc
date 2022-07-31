defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv
  alias Mc.Modifier.Get
  alias Mc.Modifier.Prepend

  setup do
    start_supervised({Kv, map: %{"star" => "light", "thing" => "ready"}})
    start_supervised({Get, kv_client: Kv})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Prepend.modify/2" do
    test "parses `args` as an 'inline string' and prepends it to `buffer`" do
      assert Prepend.modify("23", "1") == {:ok, "123"}
      assert Prepend.modify("\nbar", "foo") == {:ok, "foo\nbar"}
      assert Prepend.modify("\nroo", "foo; bar") == {:ok, "foo\nbar\nroo"}
      assert Prepend.modify("pend", "pre%09") == {:ok, "pre\tpend"}
      assert Prepend.modify("the buff", "%%0a") == {:ok, "%\nthe buff"}
    end

    test "prepends the 'value' associated with the 'key' to the `buffer` ('key' switch)" do
      assert Prepend.modify(" steady go!", "--key thing") == {:ok, "ready steady go!"}
      assert Prepend.modify("same same", "-k no.exist") == {:ok, "same same"}
    end

    test "errors when no key is given ('key' switch)" do
      assert Prepend.modify("", "--key") == {:error, "Mc.Modifier.Prepend#modify: switch parse error"}
      assert Prepend.modify("", "-k") == {:error, "Mc.Modifier.Prepend#modify: switch parse error"}
    end

    test "returns a help message" do
      assert Check.has_help?(Prepend, :modify)
    end

    test "errors with unknown switches" do
      assert Prepend.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Prepend#modify: switch parse error"}
      assert Prepend.modify("n/a", "-u") == {:error, "Mc.Modifier.Prepend#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Prepend.modify({:ok, " three"}, "best of") == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Prepend.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
