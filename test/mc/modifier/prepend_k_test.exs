defmodule Mc.Modifier.PrependKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.PrependK

  setup do
    map = %{"star" => "light", "thing" => "ready"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: %Mc.Mappings{}}
  end

  describe "modify/3" do
    test "prepends the 'value' associated with the 'key' to the `buffer`", %{mappings: mappings} do
      assert PrependK.modify(" steady go!", "thing", mappings) == {:ok, "ready steady go!"}
      assert PrependK.modify(" switch", "star", mappings) == {:ok, "light switch"}
      assert PrependK.modify("same", "key-no-exist", mappings) == {:ok, "same"}
      assert PrependK.modify("same", "", mappings) == {:ok, "same"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert PrependK.modify({:ok, " beam"}, "star", mappings) == {:ok, "light beam"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert PrependK.modify({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
