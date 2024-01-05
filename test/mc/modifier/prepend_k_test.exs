defmodule Mc.Modifier.PrependKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.PrependK

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"star" => "light", "thing" => "ready"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "prepends the 'value' associated with the 'key' to the `buffer`" do
      assert PrependK.modify(" steady go!", "thing", %Mappings{}) == {:ok, "ready steady go!"}
      assert PrependK.modify(" switch", "star", %Mappings{}) == {:ok, "light switch"}
      assert PrependK.modify("same", "key-no-exist", %Mappings{}) == {:ok, "same"}
      assert PrependK.modify("same", "", %Mappings{}) == {:ok, "same"}
    end

    test "works with ok tuples" do
      assert PrependK.modify({:ok, " beam"}, "star", %Mappings{}) == {:ok, "light beam"}
    end

    test "allows error tuples to pass through" do
      assert PrependK.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
