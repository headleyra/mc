defmodule Mc.Modifier.ZipTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Zip
  alias Mc.Modifier.Get

  setup do
    map = %{"z1" => "forda money\nforda show", "z2" => "bar"}
    start_supervised({KvMemory, map: map, name: :mem})
    start_supervised({Get, kv_pid: :mem})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "modify/2" do
    test "zips together the `buffer` and a KV value using a 'separator'" do
      assert Zip.modify("one\ntwo", "z1 *") == {:ok, "one*forda money\ntwo*forda show"}
      assert Zip.modify("bish\nbosh", "z2 |") == {:ok, "bish|bar"}
      assert Zip.modify("million\t", "z1 |") == {:ok, "million\t|forda money"}
    end

    @errmsg "Mc.Modifier.Zip#modify: parse error"

    test "errors when `args` can't be parsed" do
      assert Zip.modify("n/a", "too many args") == {:error, @errmsg}
      assert Zip.modify("", "too.few.args") == {:error, @errmsg}
    end

    test "interprets the separator as a URI-encoded string" do
      assert Zip.modify("one\ntwo", "z1 %20") == {:ok, "one forda money\ntwo forda show"}
      assert Zip.modify("one\ntwo", "z1 %0a ") == {:ok, "one\nforda money\ntwo\nforda show"}
      assert Zip.modify("one\ntwo", "z1 %09") == {:ok, "one\tforda money\ntwo\tforda show"}
      assert Zip.modify("one\ntwo", "z1 %%09") == {:ok, "one%\tforda money\ntwo%\tforda show"}
    end

    test "works when the key doesn't exist" do
      assert Zip.modify("one\ntwo", "nope *") == {:ok, "one*"}
    end

    test "works when the `buffer` is empty" do
      assert Zip.modify("", "z1 =") == {:ok, "=forda money"}
      assert Zip.modify("", "nah :") == {:ok, ":"}
      assert Zip.modify("", "z1 @") == {:ok, "@forda money"}
    end

    test "works with ok tuples" do
      assert Zip.modify({:ok, "1\n2"}, "z1 -") == {:ok, "1-forda money\n2-forda show"}
    end

    test "allows error tuples to pass through" do
      assert Zip.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
