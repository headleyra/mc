defmodule Mc.Modifier.ZipTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Zip

  setup do
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as: <sep> <script1><sep> <script2>[<sep> <URI-encoded separator>]", do: true

    test "zips together the result of running two scripts", %{mappings: mappings} do
      assert Zip.m("", ", b one; two; three, range 3", mappings) == {:ok, "one1\ntwo2\nthree3"}
      assert Zip.m("", "// b wine; gin// b -bar; -tonic", mappings) == {:ok, "wine-bar\ngin-tonic"}
    end

    test "runs the scripts against the `buffer`", %{mappings: mappings} do
      assert Zip.m("un\ndeux", ", map append >, map prepend <", mappings) == {:ok, "un><un\ndeux><deux"}
      assert Zip.m("x\ny", ", getb, getb", mappings) == {:ok, "xx\nyy"}
    end

    test "short-circuits to the shortest of the script results", %{mappings: mappings} do
      assert Zip.m("", ", b one; two, b 1; 2; 3; 4", mappings) == {:ok, "one1\ntwo2"}
      assert Zip.m("", "@ b 1; 2; 3; 4@ b one; two", mappings) == {:ok, "1one\n2two"}
      assert Zip.m("", ", b, b foo; bar", mappings) == {:ok, "foo"}
    end

    test "works with URI-encoded separators", %{mappings: mappings} do
      assert Zip.m("", ", b one; two; three, range 3, %20", mappings) == {:ok, "one 1\ntwo 2\nthree 3"}
      assert Zip.m("", ", b aa; bb, range 2, -", mappings) == {:ok, "aa-1\nbb-2"}
      assert Zip.m("", ", b foo; bar, range 2, %25%09:", mappings) == {:ok, "foo%\t:1\nbar%\t:2"}
    end

    test "returns script errors", %{mappings: mappings} do
      assert Zip.m("", ", b ok script, bad1 script", mappings) == {:error, "Mc.Modifier.Zip: modifier not found: bad1"}
      assert Zip.m("", ", bad2 script, b ok script", mappings) == {:error, "Mc.Modifier.Zip: modifier not found: bad2"}
      assert Zip.m("", ", range bad3, range bad4", mappings) == {:error, "Mc.Modifier.Zip: Mc.Modifier.Range: bad range"}
    end

    test "errors when `args` can't be parsed", %{mappings: mappings} do
      assert Zip.m("", "", mappings) == {:error, "Mc.Modifier.Zip: parse error"}
      assert Zip.m("", ", ", mappings) == {:error, "Mc.Modifier.Zip: parse error"}
      assert Zip.m("", "foo bar", mappings) == {:error, "Mc.Modifier.Zip: parse error"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Zip.m({:ok, "one\ntwo"}, ", map append -, map prepend :", mappings) == {:ok, "one-:one\ntwo-:two"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Zip.m({:error, "reason"}, "range 5", mappings) == {:error, "reason"}
    end
  end
end
