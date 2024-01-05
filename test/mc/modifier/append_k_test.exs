defmodule Mc.Modifier.AppendKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppendK

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
    ]
  end

  setup do
    map = %{"star" => "light", "thing" => "bar"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a 'key' and appends its value to the `buffer`" do
      assert AppendK.modify("raise the ", "thing", %Mappings{}) == {:ok, "raise the bar"}
      assert AppendK.modify("same", "key.no.exist", %Mappings{}) == {:ok, "same"}
      assert AppendK.modify("same", "", %Mappings{}) == {:ok, "same"}
    end

    test "works with ok tuples" do
      assert AppendK.modify({:ok, "bright "}, "star", %Mappings{}) == {:ok, "bright light"}
    end

    test "allows error tuples to pass through" do
      assert AppendK.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
