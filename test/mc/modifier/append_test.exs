defmodule Mc.Modifier.AppendTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv
  alias Mc.Modifier.Get
  alias Mc.Modifier.Append

  setup do
    start_supervised({Kv, map: %{"star" => "light", "thing" => "bar"}})
    start_supervised({Get, kv_client: Kv})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Append.modify/2" do
    test "parses `args` as an 'inline string' and appends it to `buffer`" do
      assert Append.modify("12", "3") == {:ok, "123"}
      assert Append.modify("foo\n", "bar") == {:ok, "foo\nbar"}
      assert Append.modify("foo\n", "bar; roo") == {:ok, "foo\nbar\nroo"}
      assert Append.modify("ap", "%09pend") == {:ok, "ap\tpend"}
      assert Append.modify("the buff", "%%0a") == {:ok, "the buff%\n"}
    end

    test "fetches the value of the 'key' and appends it to the `buffer` ('key' switch)" do
      assert Append.modify("raise the ", "--key thing") == {:ok, "raise the bar"}
      assert Append.modify("same same", "-k no.exist") == {:ok, "same same"}
    end

    test "errors when no key is given ('key' switch)" do
      assert Append.modify("", "--key") == {:error, "Mc.Modifier.Append#modify: switch parse error"}
      assert Append.modify("", "-k") == {:error, "Mc.Modifier.Append#modify: switch parse error"}
    end

    test "returns a help message" do
      assert Check.has_help?(Append, :modify)
    end

    test "errors with unknown switches" do
      assert Append.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Append#modify: switch parse error"}
      assert Append.modify("n/a", "-u") == {:error, "Mc.Modifier.Append#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Append.modify({:ok, "best of "}, "three") == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Append.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
