defmodule Mc.Modifier.IfKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.IfK

  setup do
    map = %{"compare-key" => "this", "empty-string" => "", "nah" => "that"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "compares `buffer` and 'compare-key' (value); returns 'true-value' if equal, 'false-value' if not" do
      assert IfK.modify("this", "compare-key true-value false-value", %Mc.Mappings{}) == {:ok, "true-value"}
      assert IfK.modify("other", "nah true-say nope!", %Mc.Mappings{}) == {:ok, "nope!"}
      assert IfK.modify("", "empty-string true:value false:value", %Mc.Mappings{}) == {:ok, "true:value"}
      assert IfK.modify("not empty", "empty-string true:value false:value", %Mc.Mappings{}) == {:ok, "false:value"}
    end

    test "works with URI encoded true/false values" do
      assert IfK.modify("this", "compare-key true%09value false-value", %Mc.Mappings{}) == {:ok, "true\tvalue"}
      assert IfK.modify("1234", "nah true-value false%25value", %Mc.Mappings{}) == {:ok, "false%value"}
    end

    @errmsg "Mc.Modifier.IfK: parse error"

    test "errors without exactly 3 parse items" do
      assert IfK.modify("n/a", "just-one", %Mc.Mappings{}) == {:error, @errmsg}
      assert IfK.modify("", "one two three four", %Mc.Mappings{}) == {:error, @errmsg}
      assert IfK.modify("", "", %Mc.Mappings{}) == {:error, @errmsg}
      assert IfK.modify("", "1 2", %Mc.Mappings{}) == {:error, @errmsg}
    end

    test "works with ok tuples" do
      assert IfK.modify({:ok, "this"}, "compare-key green%20light red", %Mc.Mappings{}) == {:ok, "green light"}
    end

    test "allows error tuples to pass through" do
      assert IfK.modify({:error, "reason"}, "na", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
