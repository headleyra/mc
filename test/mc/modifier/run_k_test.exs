defmodule Mc.Modifier.RunKTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.RunK

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get,
      lcase: Mc.Modifier.Lcase,
      replace: Mc.Modifier.Replace
    ]
  end

  setup do
    map =
      %{
        "s1" => "replace FOO RADIO\nlcase",
        "s2" => "lcase\nreplace bass treble\nreplace one two",
        "s3" => ""
      }

    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "'runs' the script referenced by 'key' on the `buffer`" do
      assert RunK.modify("stay in FOO contact", "s1", %Mappings{}) == {:ok, "stay in radio contact"}
      assert RunK.modify("one 4 da BASS", "s3", %Mappings{}) == {:ok, "one 4 da BASS"}
      assert RunK.modify("one 4 da BASS", "s2", %Mappings{}) == {:ok, "two 4 da treble"}
    end

    test "returns `buffer` when 'key' references a script that doesn't exist" do
      assert RunK.modify("still the same", "nope", %Mappings{}) == {:ok, "still the same"}
      assert RunK.modify("abc", "", %Mappings{}) == {:ok, "abc"}
    end

    test "works with ok tuples" do
      assert RunK.modify({:ok, "FOO"}, "s1", %Mappings{}) == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert RunK.modify({:error, "reason"}, "s2", %Mappings{}) == {:error, "reason"}
    end
  end
end
