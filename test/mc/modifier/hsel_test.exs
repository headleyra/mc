defmodule Mc.Modifier.HselTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Hsel

  setup do
    %{
      html: """
      <h1>two > one</h1>
      <p class="first desc">Foo Bar</p>
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
      <p class="deets">John Doe</p>
      """
    }
  end

  describe "m/3" do
    test "returns empty when `buffer` is empty" do
      assert Hsel.m("", "", %{}) == {:ok, ""}
      assert Hsel.m("", "p", %{}) == {:ok, ""}
      assert Hsel.m("\n \t", "li", %{}) == {:ok, ""}
    end

    test "uses `args` as a CSS selector to target HTML elements", %{html: html} do
      assert Hsel.m(html, "p", %{}) ==
        {:ok, "<p class=\"first desc\">Foo Bar</p>\n<p class=\"deets\">John Doe</p>"}
    end

    test "ignores elements that don't exist", %{html: html} do
      assert Hsel.m(html, "tbody", %{}) == {:ok, ""}
    end

    test "targets elements by class", %{html: html} do
      assert Hsel.m(html, ".item", %{}) == {:ok, "<td class=\"item\">Book</td>"}
    end

    test "does not 'URI encode' characters (e.g., '>')", %{html: html} do
      assert Hsel.m(html, "h1", %{}) == {:ok, "<h1>two > one</h1>"}
    end

    test "targets nested elements", %{html: html} do
      assert Hsel.m(html, "#second td.desc", %{}) == {:ok, "<td class=\"desc\">A great read!</td>"}
    end

    test "targets lists of elements", %{html: html} do
      assert Hsel.m(html, ".item, .deets", %{}) ==
        {:ok, "<td class=\"item\">Book</td>\n<p class=\"deets\">John Doe</p>"}
    end
  end
end
