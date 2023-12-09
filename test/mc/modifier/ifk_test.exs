defmodule Mc.Modifier.IfkTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Ifk

  defmodule Mappings do
    defstruct [
      get: {Mc.Modifier.Get, :modify}
    ]
  end

  setup do
    map = %{"compare-key" => "this", "empty-string" => "", "nah" => "that"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "compares `buffer` and 'compare-key' (value); returns 'true-value' if equal, 'false-value' if not" do
      assert Ifk.modify("this", "compare-key true-value false-value", %Mappings{}) == {:ok, "true-value"}
      assert Ifk.modify("other", "nah true-say nope!", %Mappings{}) == {:ok, "nope!"}
      assert Ifk.modify("", "empty-string true:value false:value", %Mappings{}) == {:ok, "true:value"}
      assert Ifk.modify("not empty", "empty-string true:value false:value", %Mappings{}) == {:ok, "false:value"}
    end

    test "works with URI encoded true/false values" do
      assert Ifk.modify("this", "compare-key true%09value false-value", %Mappings{}) == {:ok, "true\tvalue"}
      assert Ifk.modify("1234", "nah true-value false%25value", %Mappings{}) == {:ok, "false%value"}
    end

    @errmsg "Mc.Modifier.Ifk#modify: parse error"

    test "errors without exactly 3 parse items" do
      assert Ifk.modify("n/a", "just-one", %Mappings{}) == {:error, @errmsg}
      assert Ifk.modify("", "one two three four", %Mappings{}) == {:error, @errmsg}
      assert Ifk.modify("", "", %Mappings{}) == {:error, @errmsg}
      assert Ifk.modify("", "1 2", %Mappings{}) == {:error, @errmsg}
    end

    test "works with ok tuples" do
      assert Ifk.modify({:ok, "this"}, "compare-key green%20light red", %Mappings{}) == {:ok, "green light"}
    end

    test "allows error tuples to pass through" do
      assert Ifk.modify({:error, "reason"}, "na", %Mappings{}) == {:error, "reason"}
    end
  end
end
