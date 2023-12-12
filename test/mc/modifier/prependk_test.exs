defmodule Mc.Modifier.PrependkTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Prependk

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"star" => "light", "thing" => "ready"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "prepends the 'value' associated with the 'key' to the `buffer`" do
      assert Prependk.modify(" steady go!", "thing", %Mappings{}) == {:ok, "ready steady go!"}
      assert Prependk.modify(" switch", "star", %Mappings{}) == {:ok, "light switch"}
      assert Prependk.modify("same", "key-no-exist", %Mappings{}) == {:ok, "same"}
      assert Prependk.modify("same", "", %Mappings{}) == {:ok, "same"}
    end

    test "works with ok tuples" do
      assert Prependk.modify({:ok, " beam"}, "star", %Mappings{}) == {:ok, "light beam"}
    end

    test "allows error tuples to pass through" do
      assert Prependk.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
