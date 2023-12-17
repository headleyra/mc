defmodule Mc.Modifier.HselCTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.HselC

  setup do
    %{
      html: """
      <p class="first desc">
        Foo bar
      </p>
      <div>
        <table>
          <tr><td>Lorem ipsum</td></tr>
          <tr><td>The quick fox</td></tr>
        </table>
      </div>
      <div id="second">
        <table>
          <tr><td class="item">Book</td></tr>
          <tr><td class="desc">A great read!</td></tr>
        </table>
      </div>
      <p class="deets">
        John Doe
      </p>
      <h1>2 > 1</h1>
      """
    }
  end

  describe "modify/3" do
    test "parses `args` as a CSS selector and targets HTML *content* in the `buffer`", do: true
    
    test "returns empty string when `buffer` is empty string" do
      assert HselC.modify("", "", %{}) == {:ok, ""}
      assert HselC.modify("", "p", %{}) == {:ok, ""}
    end

    test "returns content without tags", %{html: html} do
      assert HselC.modify(html, "p", %{}) == {:ok, "Foo bar\nJohn Doe"}
    end

    test "targets embedded elements", %{html: html} do
      assert HselC.modify(html, "table", %{}) == {:ok, "Lorem ipsum The quick fox\nBook A great read!"}
    end

    test "ignores elements that don't exist", %{html: html} do
      assert HselC.modify(html, "tbody", %{}) == {:ok, ""}
    end

    test "targets elements ", %{html: html} do
      assert HselC.modify(html, ".item", %{}) == {:ok, "Book"}
    end

    test "targets nested elements", %{html: html} do
      assert HselC.modify(html, "#second td.desc", %{}) == {:ok, "A great read!"}
    end

    test "targets lists of elements", %{html: html} do
      assert HselC.modify(html, ".desc, .deets", %{}) == {:ok, "Foo bar\nA great read!\nJohn Doe"}
    end

    test "works with ok tuples", %{html: html} do
      assert HselC.modify({:ok, html}, ".item", %{}) == {:ok, "Book"}
    end

    test "allows error tuples to pass through" do
      assert HselC.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
