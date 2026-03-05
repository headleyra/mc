defmodule Mc.Modifier.AppendKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppendK

  setup do
    map = %{"star" => "light", "thing" => "bar"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as a 'key' and appends its value to the `buffer`", %{mappings: mappings} do
      assert AppendK.m("raise the ", "thing", mappings) == {:ok, "raise the bar"}
      assert AppendK.m("same", "key.no.exist", mappings) == {:ok, "same"}
      assert AppendK.m("same", "", mappings) == {:ok, "same"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert AppendK.m({:ok, "bright "}, "star", mappings) == {:ok, "bright light"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert AppendK.m({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
