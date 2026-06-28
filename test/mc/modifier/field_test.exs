defmodule Mc.Modifier.FieldTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Field

  describe "m/3" do
    test "uses 'select specs' as defined in `Ut.Select`", do: true
    test "parses `args` as: <select spec> <separator> <joiner>", do: true

    test "separates, selects and joins the `buffer`" do
      assert Field.m("one.two.three", "1,3,2 . //", %{}) == {:ok, "one//three//two"}
    end

    test "works with URI-encoded separators and joiners" do
      assert Field.m("un\ndeux\ntrois", "1,3,2 %0a %20", %{}) == {:ok, "un trois deux"}
    end

    test "errors when `args` can't be parsed (select spec contains a zero)" do
      assert Field.m("oops-bad-spec", "0,1 - /", %{}) == {:error, Mc.Modifier.Field, :parse_error, "0,1 - /", []}
    end

    test "errors when `args` can't be parsed (it's empty)" do
      assert Field.m("empty", "", %{}) == {:error, Mc.Modifier.Field, :parse_error, "", []}
    end

    test "errors when `args` can't be parsed (only the select spec supplied)" do
      assert Field.m("spec-only", "2-5", %{}) == {:error, Mc.Modifier.Field, :parse_error, "2-5", []}
    end

    test "errors when `args` can't be parsed (missing joiner)" do
      assert Field.m("no-joiner", "1-5 -", %{}) == {:error, Mc.Modifier.Field, :parse_error, "1-5 -", []}
    end

    test "errors when `args` can't be parsed (extra string after joiner)" do
      assert Field.m("not-needed-field", "1-3 : = extra", %{}) ==
        {:error, Mc.Modifier.Field, :parse_error, "1-3 : = extra", []}
    end

    test "works with ok-tuples" do
      assert Field.m({:ok, "1/2/3/4"}, "4,4,2 / -", %{}) == {:ok, "4-4-2"}
    end

    test "allows error-tuples to pass through" do
      assert Field.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
