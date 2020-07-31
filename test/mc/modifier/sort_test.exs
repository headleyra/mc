defmodule Mc.Modifier.SortTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sort

  setup do
    %{
      text: """
        zebra crossing
      strawberries
      apples

      oranges lemons
      0-rated vat
      """
    }
  end

  describe "Mc.Modifier.Sort.modify/2" do
    test "sorts the `buffer`", %{text: text} do
      assert Sort.modify(text, "") == {:ok, """


        zebra crossing
      0-rated vat
      apples
      oranges lemons
      strawberries
      """
      }
    end

    test "works with ok tuples" do
      assert Sort.modify({:ok, "banana\napple\ntomatoe"}, "n/a") == {:ok, "apple\nbanana\ntomatoe\n"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Sort.modify({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Sort.modifyv/2" do
    test "reverse sorts the `buffer`", %{text: text} do
      assert Sort.modifyv(text, "") == {:ok, """
      strawberries
      oranges lemons
      apples
      0-rated vat
        zebra crossing


      """
      }
    end

    test "works with ok tuples" do
      assert Sort.modifyv({:ok, "banana\napple\ntomatoe"}, "n/a") == {:ok, "tomatoe\nbanana\napple\n"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Sort.modifyv({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Sort.sorter/2" do
    test "sorts lines of text (ascending)", %{text: text} do
      assert Sort.sorter(text, :asc) == """


        zebra crossing
      0-rated vat
      apples
      oranges lemons
      strawberries
      """
    end

    test "sorts lines of text (descending)", %{text: text} do
      assert Sort.sorter(text, :dsc) == """
      strawberries
      oranges lemons
      apples
      0-rated vat
        zebra crossing


      """
    end
  end
end
