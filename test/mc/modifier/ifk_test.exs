defmodule Mc.Modifier.IfkTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Ifk

  setup do
    start_supervised({Memory, map: %{
      "compare-key" => "this",
      "empty-string" => "",
      "nah" => "that"
    }, name: :mem})
    start_supervised({Get, kv_client: Memory, kv_pid: :mem})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Ifk.modify/2" do
    test "compares `buffer` and 'compare-key' (value); returns 'true-value' if equal, 'false-value' if not" do
      assert Ifk.modify("this", "compare-key true-value false-value") == {:ok, "true-value"}
      assert Ifk.modify("other", "nah true-say nope!") == {:ok, "nope!"}
      assert Ifk.modify("", "empty-string true:value false:value") == {:ok, "true:value"}
      assert Ifk.modify("not empty", "empty-string true:value false:value") == {:ok, "false:value"}
    end

    test "works with URI encoded true/false values" do
      assert Ifk.modify("this", "compare-key true%09value false-value") == {:ok, "true\tvalue"}
      assert Ifk.modify("1234", "nah true-value false%25value") == {:ok, "false%value"}
    end

    @errmsg "Mc.Modifier.Ifk#modify: parse error"

    test "errors without exactly 3 parse items" do
      assert Ifk.modify("n/a", "just-one") == {:error, @errmsg}
      assert Ifk.modify("", "one two three four") == {:error, @errmsg}
      assert Ifk.modify("", "") == {:error, @errmsg}
      assert Ifk.modify("", "1 2") == {:error, @errmsg}
    end

    test "works with ok tuples" do
      assert Ifk.modify({:ok, "this"}, "compare-key green%20light red") == {:ok, "green light"}
    end

    test "allows error tuples to pass through" do
      assert Ifk.modify({:error, "reason"}, "na") == {:error, "reason"}
    end
  end
end
