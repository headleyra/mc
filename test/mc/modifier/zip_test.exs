defmodule Mc.Modifier.ZipTest do
  use ExUnit.Case, async: true

  alias Mc.Modifier.Zip

  setup do
    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "zips `buffer` and the result of running `args` as a script", %{mappings: mappings} do
      assert Zip.modify("one\ntwo\nthree", "range 3", mappings) == {:ok, "one1\ntwo2\nthree3"}
      assert Zip.modify("wine\ngin", "b -bar; -tonic", mappings) == {:ok, "wine-bar\ngin-tonic"}
    end

    test "runs the script against the `buffer`", %{mappings: mappings} do
      assert Zip.modify("un\ndeux", "map prepend *", mappings) == {:ok, "un*un\ndeux*deux"}
    end

    test "short-circuits the zip to the shortest thing", %{mappings: mappings} do
      assert Zip.modify("one\ntwo", "b 1; 2; 3; 4", mappings) == {:ok, "one1\ntwo2"}
      assert Zip.modify("1\n2\n3\n4", "b one; two", mappings) == {:ok, "1one\n2two"}
      assert Zip.modify("", "b foo; bar", mappings) == {:ok, "foo"}
    end

    test "passes on errors from the script", %{mappings: mappings} do
      assert Zip.modify("n/a", "foo", mappings) == {:error, "Mc.Modifier.Zip: modifier not found: foo"}

      assert Zip.modify("n/a", "range", mappings) ==
        {:error, "Mc.Modifier.Zip: Mc.Modifier.Range: bad range"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Zip.modify({:ok, "1\n2"}, "range 2", mappings) == {:ok, "11\n22"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Zip.modify({:error, "reason"}, "range 5", mappings) == {:error, "reason"}
    end
  end
end
