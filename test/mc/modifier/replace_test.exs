defmodule Mc.Modifier.ReplaceTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Replace

  describe "Mc.Modifier.Replace.modify/2" do
    test "splits `args` (on the *first* space) into search and replace terms and returns `buffer`
      with the replacement applied", do: assert true

    test "works with simple replacements" do
      assert Replace.modify("stuff like this", "this THAT") == {:ok, "stuff like THAT"}
      assert Replace.modify("one four", "one four 2") == {:ok, "four 2 four"}
      assert Replace.modify("2x", "x  is company") == {:ok, "2 is company"}
      assert Replace.modify("one", "one two three") == {:ok, "two three"}
      assert Replace.modify("one", "one   2 leading spaces") == {:ok, "  2 leading spaces"}

      times = """
      \t11:16\t[ABC]
      \t11:16\t[XYZ]
      """
      assert Replace.modify(times, ~S"^\t *") == {:ok, """
      *11:16\t[ABC]
      *11:16\t[XYZ]
      """
      }
    end

    test "returns `buffer` when the search term does not match" do
      assert Replace.modify("foo bar\n", "no.match replace.with.this") == {:ok, "foo bar\n"}
      assert Replace.modify("joe 90", "foo bar") == {:ok, "joe 90"}
      assert Replace.modify("", "one two") == {:ok, ""}
    end

    test "works with a URI-encoded replacement term" do
      assert Replace.modify("alpha beta", "alpha %0a %09") == {:ok, "\n \t beta"}
      assert Replace.modify("foo", "foo %%0a") == {:ok, "%\n"}
    end

    test "works with a regex search term" do
      assert Replace.modify("sunshine all day", "sh.*da n") == {:ok, "sunny"}
    end

    test "replaces over newlines" do
      assert Replace.modify("one\ntwo\nthree", "one.*t p") == {:ok, "phree"}
    end

    test "replaces multiple occurrences of the search term" do
      assert Replace.modify("Foo bar foobar abc", "[Bb]ar Biz") == {:ok, "Foo Biz fooBiz abc"}
    end

    test "errors when the replace term is missing" do
      assert Replace.modify("3s a crowd", "search") ==
        {:error, "Mc.Modifier.Replace#modify: bad search/replace or search regex"}
    end

    test "errors when the search and replace terms are missing" do
      assert Replace.modify("bish bosh", "") ==
        {:error, "Mc.Modifier.Replace#modify: bad search/replace or search regex"}
    end

    test "errors when the search regex is bad" do
      assert Replace.modify("n/a", ") foo") ==
        {:error, "Mc.Modifier.Replace#modify: bad search/replace or search regex"}

      assert Replace.modify("(foo)", "(?=)) bar") ==
        {:error, "Mc.Modifier.Replace#modify: bad search/replace or search regex"}
    end

    test "returns a help message" do
      assert Check.has_help?(Replace, :modify)
    end

    test "errors with unknown switches" do
      assert Replace.modify("", "--unknown") == {:error, "Mc.Modifier.Replace#modify: switch parse error"}
      assert Replace.modify("", "-u") == {:error, "Mc.Modifier.Replace#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Replace.modify({:ok, "foo bar"}, "foo night") == {:ok, "night bar"}
    end

    test "allows error tuples to pass through" do
      assert Replace.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
