defmodule Mc.Modifier.SelectTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Select

  describe "m/3" do
    test "see Mc.Select.parse/1", do: true

    test "selects lines from `buffer` using a 'select spec'" do
      assert Select.m("one\ntwo\nthree", "2", %{}) == {:ok, "two"}
      assert Select.m("one\ntwo\nthree", "3", %{}) == {:ok, "three"}
      assert Select.m("un\ndeux\ntrois\n\n", "2,4,5", %{}) == {:ok, "deux\n\n"}
      assert Select.m("\n\none\ntwo\nthree\n\n", "5,3", %{}) == {:ok, "three\none"}
      assert Select.m("one\ntwo\nthree\nfour", "2-4", %{}) == {:ok, "two\nthree\nfour"}
      assert Select.m("one\ntwo\nthree\nfour\nfive", "1,3-5,1", %{}) == {:ok, "one\nthree\nfour\nfive\none"}
      assert Select.m("one\ntwo\nthree\nfour\nfive", "3-1,5", %{}) == {:ok, "three\ntwo\none\nfive"}
    end

    @reason "Mc.Modifier.Select: Mc.Modifier.Field: bad select spec"

    test "errors with bad 'select specs'" do
      assert Select.m("one\ntwo", "oops", %{}) == {:error, @reason}
      assert Select.m("one\ntwo", "5.1", %{}) == {:error, @reason}
    end

    test "errors when zero is mentioned" do
      assert Select.m("one\ntwo", "0", %{}) == {:error, @reason}
      assert Select.m("one\ntwo", "0-3", %{}) == {:error, @reason}
      assert Select.m("one\ntwo", "1,0-5", %{}) == {:error, @reason}
    end

    test "works with ok tuples" do
      assert Select.m({:ok, "one\nmore"}, "2", %{}) == {:ok, "more"}
    end

    test "allows error tuples to pass-through" do
      assert Select.m({:error, "reason"}, "1", %{}) == {:error, "reason"}
    end
  end
end
