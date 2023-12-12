defmodule Mc.Modifier.ZipTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Zip

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"z1" => "forda money\nforda show", "z2" => "bar\ntonic"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "zips together the `buffer` and a KV value using a 'separator'" do
      assert Zip.modify("one\ntwo", "z1 *", %Mappings{}) == {:ok, "one*forda money\ntwo*forda show"}
      assert Zip.modify("wine\ngin", "z2 |", %Mappings{}) == {:ok, "wine|bar\ngin|tonic"}
      assert Zip.modify("million\t", "z1 -", %Mappings{}) == {:ok, "million\t-forda money"}
    end

    @errmsg "Mc.Modifier.Zip: parse error"

    test "errors when `args` can't be parsed" do
      assert Zip.modify("n/a", "too many args", %Mappings{}) == {:error, @errmsg}
      assert Zip.modify("", "too.few.args", %Mappings{}) == {:error, @errmsg}
    end

    test "interprets the separator as a URI-encoded string" do
      assert Zip.modify("one\ntwo", "z1 %20", %Mappings{}) == {:ok, "one forda money\ntwo forda show"}
      assert Zip.modify("one\ntwo", "z1 %0a ", %Mappings{}) == {:ok, "one\nforda money\ntwo\nforda show"}
      assert Zip.modify("one\ntwo", "z1 %09", %Mappings{}) == {:ok, "one\tforda money\ntwo\tforda show"}
      assert Zip.modify("one\ntwo", "z1 %%09", %Mappings{}) == {:ok, "one%\tforda money\ntwo%\tforda show"}
    end

    test "works when the key doesn't exist" do
      assert Zip.modify("one\ntwo", "key-no-exist *", %Mappings{}) == {:ok, "one*"}
    end

    test "works when the `buffer` is empty" do
      assert Zip.modify("", "z1 =", %Mappings{}) == {:ok, "=forda money"}
      assert Zip.modify("", "nah :", %Mappings{}) == {:ok, ":"}
      assert Zip.modify("", "z1 @", %Mappings{}) == {:ok, "@forda money"}
    end

    test "works with ok tuples" do
      assert Zip.modify({:ok, "1\n2"}, "z1 -", %Mappings{}) == {:ok, "1-forda money\n2-forda show"}
    end

    test "allows error tuples to pass through" do
      assert Zip.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
