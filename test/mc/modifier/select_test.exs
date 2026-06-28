defmodule Mc.Modifier.SelectTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Select

  describe "m/3" do
    test "uses 'select specs' as defined in `Ut.Select`", do: true

    test "selects lines from `buffer` (using a select spec)" do
      assert Select.m("one\ntwo\nthree", "2", %{}) == {:ok, "two"}
      assert Select.m("one\ntwo\nthree", "3", %{}) == {:ok, "three"}
      assert Select.m("un\ndeux\ntrois\n\n", "2,4,5", %{}) == {:ok, "deux\n\n"}
      assert Select.m("\n\none\ntwo\nthree\n\n", "5,3", %{}) == {:ok, "three\none"}
      assert Select.m("one\ntwo\nthree\nfour", "2-4", %{}) == {:ok, "two\nthree\nfour"}
      assert Select.m("one\ntwo\nthree\nfour\nfive", "1,3-5,1", %{}) == {:ok, "one\nthree\nfour\nfive\none"}
      assert Select.m("one\ntwo\nthree\nfour\nfive", "3-1,5", %{}) == {:ok, "three\ntwo\none\nfive"}
    end

    test "errors with bad select specs (non integers)" do
      assert Select.m("one\ntwo", "oops", %{}) ==
        {:error, Mc.Modifier.Select, :parse_error, "oops", [{Mc.Modifier.Field, :parse_error, "oops %0a %0a"}]}

      assert Select.m("one\ntwo", "5.1", %{}) ==
        {:error, Mc.Modifier.Select, :parse_error, "5.1", [{Mc.Modifier.Field, :parse_error, "5.1 %0a %0a"}]}
    end

    test "errors with bad select specs (zeroes not allowed)" do
      assert Select.m("one\ntwo", "0", %{}) ==
        {:error, Mc.Modifier.Select, :parse_error, "0", [{Mc.Modifier.Field, :parse_error, "0 %0a %0a"}]}

      assert Select.m("one\ntwo", "0-3", %{}) ==
        {:error, Mc.Modifier.Select, :parse_error, "0-3", [{Mc.Modifier.Field, :parse_error, "0-3 %0a %0a"}]}

      assert Select.m("one\ntwo", "1,0-5", %{}) ==
        {:error, Mc.Modifier.Select, :parse_error, "1,0-5", [{Mc.Modifier.Field, :parse_error, "1,0-5 %0a %0a"}]}
    end

    test "works with ok-tuples" do
      assert Select.m({:ok, "one\nmore"}, "2", %{}) == {:ok, "more"}
    end

    test "allows error-tuples to pass-through" do
      assert Select.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
