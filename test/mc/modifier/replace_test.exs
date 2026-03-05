defmodule Mc.Modifier.ReplaceTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Replace

  describe "m/3" do
    test "splits `args` into 'search' and 'replace' terms and returns `buffer` with replacements applied" do
      assert Replace.m("stuff like this", "this THAT", %{}) == {:ok, "stuff like THAT"}
      assert Replace.m("one four", "one four 2", %{}) == {:ok, "four 2 four"}
      assert Replace.m("2x", "x is company", %{}) == {:ok, "2is company"}
      assert Replace.m("one", "one two three", %{}) == {:ok, "two three"}
      assert Replace.m("one", "one %20%202 leading spaces", %{}) == {:ok, "  2 leading spaces"}
      assert Replace.m("space man", "space   \t\n door", %{}) == {:ok, "door man"}
      assert Replace.m("bish", "bish      bosh", %{}) == {:ok, "bosh"}

      times = """
      \t11:16\t[ABC]
      \t11:16\t[XYZ]
      """

      modified_times = """
      *11:16\t[ABC]
      *11:16\t[XYZ]
      """

      assert Replace.m(times, ~S"^\t *", %{}) == {:ok, modified_times}
    end

    test "returns `buffer` when the search term does not match" do
      assert Replace.m("foo bar\n", "no.match replace.with.this", %{}) == {:ok, "foo bar\n"}
      assert Replace.m("joe 90", "foo bar", %{}) == {:ok, "joe 90"}
      assert Replace.m("", "one two", %{}) == {:ok, ""}
    end

    test "works with a URI-encoded replacement term" do
      assert Replace.m("alpha beta", "alpha %0a %09", %{}) == {:ok, "\n \t beta"}
      assert Replace.m("foo", "foo %%0a", %{}) == {:ok, "%\n"}
    end

    test "works with a regex search term" do
      assert Replace.m("sunshine all day", "sh.*da n", %{}) == {:ok, "sunny"}
    end

    test "replaces over newlines" do
      assert Replace.m("one\ntwo\nthree", "one.*t p", %{}) == {:ok, "phree"}
    end

    test "replaces multiple occurrences of the search term" do
      assert Replace.m("Foo bar foobar abc", "[Bb]ar Biz", %{}) == {:ok, "Foo Biz fooBiz abc"}
    end

    test "errors when the replace term is missing" do
      assert Replace.m("3s a crowd", "search", %{}) ==
        {:error, "Mc.Modifier.Replace: bad search/replace or search regex"}
    end

    test "errors when the search and replace terms are missing" do
      assert Replace.m("bish bosh", "", %{}) ==
        {:error, "Mc.Modifier.Replace: bad search/replace or search regex"}
    end

    test "errors when the search regex is bad" do
      assert Replace.m("n/a", ") foo", %{}) ==
        {:error, "Mc.Modifier.Replace: bad search/replace or search regex"}

      assert Replace.m("(foo)", "(?=)) bar", %{}) ==
        {:error, "Mc.Modifier.Replace: bad search/replace or search regex"}
    end

    test "works with ok tuples" do
      assert Replace.m({:ok, "foo bar"}, "foo night", %{}) == {:ok, "night bar"}
    end

    test "allows error tuples to pass through" do
      assert Replace.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
