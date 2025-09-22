defmodule Mc.Modifier.HselTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Hsel

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
    test "returns empty when `buffer` is empty" do
      assert Hsel.modify("", "", %{}) == {:ok, ""}
      assert Hsel.modify("", "p", %{}) == {:ok, ""}
      assert Hsel.modify("\n \t", "li", %{}) == {:ok, ""}
    end

    test "strips newlines from the `buffer` (HTML) before processing", do: true
    test "uses `args` as a CSS selector to target HTML elements", do: true

    test "targets elements and places them on separate lines", %{html: html} do
      assert Hsel.modify(html, "p", %{}) ==
        {:ok, "<p class=\"first desc\">  Foo bar</p>\n<p class=\"deets\">  John Doe</p>"}
    end

    test "ignores elements that don't exist", %{html: html} do
      assert Hsel.modify(html, "tbody", %{}) == {:ok, ""}
    end

    test "targets elements by class", %{html: html} do
      assert Hsel.modify(html, ".item", %{}) == {:ok, "<td class=\"item\">Book</td>"}
    end

    test "does not 'URI encode' characters (e.g., '>')", %{html: html} do
      assert Hsel.modify(html, "h1", %{}) == {:ok, "<h1>2 > 1</h1>"}
    end

    test "targets nested elements", %{html: html} do
      assert Hsel.modify(html, "#second td.desc", %{}) == {:ok, "<td class=\"desc\">A great read!</td>"}
    end

    test "targets lists of elements", %{html: html} do
      assert Hsel.modify(html, ".item, .deets", %{}) ==
        {:ok, "<td class=\"item\">Book</td>\n<p class=\"deets\">  John Doe</p>"}
    end
  end
end
