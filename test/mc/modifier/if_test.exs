defmodule Mc.Modifier.IfTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.If

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{
      "key.a" => "aaa",
      "key.z" => "zzz",
      "key.1" => "b forda money",
      "key.2" => "b 4the show",
      "apd" => "append this",
      "small" => "lcase",
      "big" => "ucase",
      "empty" => ""
    }})
    :ok
  end

  describe "Mc.Modifier.If.modify/2" do
    test "runs 'value of key' if `buffer` is 'blank', else returns `buffer`" do
      assert If.modify("", "key.1") == {:ok, "forda money"}
      assert If.modify("not blank", "na") == {:ok, "not blank"}
      assert If.modify("  ", "key.2") == {:ok, "4the show"}
      assert If.modify("foo\t\nbar", "na") == {:ok, "foo\t\nbar"}
    end

    test "errors without exactly 1 key" do
      assert If.modify("n/a", "") == {:error, "usage: Mc.Modifier.If#modify <script key>"}
      assert If.modify("", "a b") == {:error, "usage: Mc.Modifier.If#modify <script key>"}
    end

    test "works with ok tuples" do
      assert If.modify({:ok, ""}, "key.1") == {:ok, "forda money"}
      assert If.modify({:ok, "dosh"}, "na") == {:ok, "dosh"}
    end

    test "allows error tuples to pass-through" do
      assert If.modify({:error, "reason"}, "na") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.If.modifye/2" do
    test "runs 'value of key2' if `buffer` == 'value of key1' else runs 'value of key3'" do
      assert If.modifye("aaa", "key.a big small") == {:ok, "AAA"}
      assert If.modifye("NOT EQUAL", "key.z big small") == {:ok, "not equal"}
      assert If.modifye("aaa", "key.a empty oops") == {:ok, "aaa"}
      assert If.modifye("aaa", "noexist small big") == {:ok, "AAA"}
    end

    test "errors without exactly 3 keys" do
      assert If.modifye("fiscal rules", "") ==
        {:error, "usage: Mc.Modifier.If#modifye <compare key> <true key> <false key>"}

      assert If.modifye("gig economy", "one") ==
        {:error, "usage: Mc.Modifier.If#modifye <compare key> <true key> <false key>"}

      assert If.modifye("yaba daba do", "buy the dip dude") ==
        {:error, "usage: Mc.Modifier.If#modifye <compare key> <true key> <false key>"}
    end

    test "works with ok tuples" do
      assert If.modifye({:ok, "aaa"}, "key.a big any") == {:ok, "AAA"}
    end

    test "allows error tuples to pass-through" do
      assert If.modifye({:error, "reason"}, "akey") == {:error, "reason"}
    end
  end
end
