defmodule Mc.Modifier.PrependKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.PrependK

  setup do
    map = %{"star" => "light", "thing" => "ready"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "prepends the 'value' associated with the 'key' to the `buffer`", %{mappings: mappings} do
      assert PrependK.m(" steady go!", "thing", mappings) == {:ok, "ready steady go!"}
      assert PrependK.m(" switch", "star", mappings) == {:ok, "light switch"}
      assert PrependK.m("same", "key-no-exist", mappings) == {:ok, "same"}
      assert PrependK.m("same", "", mappings) == {:ok, "same"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert PrependK.m({:ok, " beam"}, "star", mappings) == {:ok, "light beam"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert PrependK.m({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
