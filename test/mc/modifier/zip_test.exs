defmodule Mc.Modifier.ZipTest do
  use ExUnit.Case, async: true

  alias Mc.Modifier.Zip

  defmodule Mappings do
    defstruct [
      b: Mc.Modifier.Buffer,
      map: Mc.Modifier.Map,
      prepend: Mc.Modifier.Prepend,
      range: Mc.Modifier.Range
    ]
  end

  describe "modify/3" do
    test "zips together the `buffer` and the result of running `args` as a script" do
      assert Zip.modify("one\ntwo\nthree", "range 3", %Mappings{}) == {:ok, "one1\ntwo2\nthree3"}
      assert Zip.modify("wine\ngin", "b -bar; -tonic", %Mappings{}) == {:ok, "wine-bar\ngin-tonic"}
    end

    test "runs the script against the `buffer`" do
      assert Zip.modify("un\ndeux", "map prepend *", %Mappings{}) == {:ok, "un*un\ndeux*deux"}
    end

    test "short-circuits the zip to the shortest thing" do
      assert Zip.modify("one\ntwo", "b 1; 2; 3; 4", %Mappings{}) == {:ok, "one1\ntwo2"}
      assert Zip.modify("1\n2\n3\n4", "b one; two", %Mappings{}) == {:ok, "1one\n2two"}
      assert Zip.modify("", "b foo; bar", %Mappings{}) == {:ok, "foo"}
    end

    test "passes on errors from the script" do
      assert Zip.modify("n/a", "foo", %Mappings{}) == {:error, "Mc.Modifier.Zip: modifier not found: foo"}

      assert Zip.modify("n/a", "range", %Mappings{}) ==
        {:error, "Mc.Modifier.Zip: Mc.Modifier.Range: bad range"}
    end

    test "works with ok tuples" do
      assert Zip.modify({:ok, "1\n2"}, "range 2", %Mappings{}) == {:ok, "11\n22"}
    end

    test "allows error tuples to pass through" do
      assert Zip.modify({:error, "reason"}, "range 5", %Mappings{}) == {:error, "reason"}
    end
  end
end
