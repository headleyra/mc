defmodule Mc.Modifier.FieldTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Field

  describe "m/3" do
    test "parses `args` as: <sep> <select spec><sep> <separator><sep> <joiner>", do: true
    test "see Mc.Select.parse/1", do: true

    test "separates, selects and joins the `buffer`" do
      assert Field.m("one.two.three", "1,3,2 . //", %{}) == {:ok, "one//three//two"}
    end

    test "works with URI-encoded separators and joiners" do
      assert Field.m("un\ndeux\ntrois", "1,3,2 %0a %20", %{}) == {:ok, "un trois deux"}
    end

    test "errors with bad 'select specs'" do
      assert Field.m("oops-bad-spec", "0,1 - /", %{}) == {:error, "Mc.Modifier.Field: bad select spec"}
    end

    test "errors when `args` can't be parsed" do
      assert Field.m("empty", "", %{}) == {:error, "Mc.Modifier.Field: parse error"}
      assert Field.m("spec-only", "2-5", %{}) == {:error, "Mc.Modifier.Field: parse error"}
      assert Field.m("no-joiner", "1-5 -", %{}) == {:error, "Mc.Modifier.Field: parse error"}
    end

    test "works with ok tuples" do
      assert Field.m({:ok, "1/2/3/4"}, "4,4,2 / -", %{}) == {:ok, "4-4-2"}
    end

    test "allows error tuples to pass through" do
      assert Field.m({:error, "reason"}, "1 - :", %{}) == {:error, "reason"}
    end
  end
end
