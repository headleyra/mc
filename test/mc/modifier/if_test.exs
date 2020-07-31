defmodule Mc.Modifier.IfTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.If

  setup do
    start_supervised({Mc, %Mc.Mappings{}})
    start_supervised({Mc.Modifier.Kv, %{
      "a_key" => "aaa",
      "z_key" => "zzz",
      "small" => "lcase",
      "big" => "ucase",
      "empty.key" => ""
    }})
    :ok
  end

  describe "Mc.Modifier.If.modifye/2" do
    test "evaluates `buffer` == 'value of arg1 key'? (and runs 'arg2' else 'arg3')" do
      assert If.modifye("aaa", "a_key big small") == {:ok, "AAA"}
      assert If.modifye("NOT EQUAL", "z_key big small") == {:ok, "not equal"}
      assert If.modifye("aaa", "a_key empty.key oops") == {:ok, "aaa"}
      assert If.modifye("aaa", "noexist small big") == {:ok, "AAA"}
    end

    test "errors when exactly 3 keys aren't provided" do
      assert If.modifye("fiscal rules", "") == {:error, "If: Bad args"}
      assert If.modifye("gig economy", "one") == {:error, "If: Bad args"}
      assert If.modifye("yaba daba do", "buy the dip dude") == {:error, "If: Bad args"}
    end

    test "works with ok tuples" do
      assert If.modifye({:ok, "aaa"}, "a_key big any") == {:ok, "AAA"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert If.modifye({:error, "reason"}, "akey") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.If.modifyl/2" do
    test "evaluates `buffer` < 'value of arg1 key'? (and runs 'arg2' else 'arg3')" do
      assert If.modifyl("zzz", "a_key small big") == {:ok, "ZZZ"}
      assert If.modifyl("GoLd", "z_key small big") == {:ok, "gold"}
      assert If.modifyl("big up", "empty.key n/a big") == {:ok, "BIG UP"}
      assert If.modifyl("zzz", "z_key small big") == {:ok, "ZZZ"}
    end

    test "errors when exactly 3 keys aren't provided" do
      assert If.modifyl("fiscal rules", "") == {:error, "If: Bad args"}
      assert If.modifyl("gig economy", "one") == {:error, "If: Bad args"}
      assert If.modifyl("yaba daba do", "buy the dip dude") == {:error, "If: Bad args"}
    end

    test "works with ok tuples" do
      assert If.modifyl({:ok, "aaa"}, "z_key big small") == {:ok, "AAA"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert If.modifyl({:error, "reason"}, "akey") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.If.modifyg/2" do
    test "evaluates `buffer` > 'value of arg1 key'? (and runs 'arg2' else 'arg3')" do
      assert If.modifyg("zzz", "a_key big small") == {:ok, "ZZZ"}
      assert If.modifyg("GoLd", "z_key small big") == {:ok, "GOLD"}
      assert If.modifyg("big up", "empty.key big nope") == {:ok, "BIG UP"}
    end

    test "errors when exactly 3 keys aren't provided" do
      assert If.modifyg("fiscal rules", "") == {:error, "If: Bad args"}
      assert If.modifyg("gig economy", "one") == {:error, "If: Bad args"}
      assert If.modifyg("yaba daba do", "buy the dip dude") == {:error, "If: Bad args"}
    end

    test "works with ok tuples" do
      assert If.modifyg({:ok, "aaa"}, "z_key small big") == {:ok, "AAA"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert If.modifyg({:error, "reason"}, "akey") == {:error, "reason"}
    end
  end
end
