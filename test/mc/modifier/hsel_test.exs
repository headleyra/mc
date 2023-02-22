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

  describe "modify/2" do
    test "parses `args` as a CSS selector and targets HTML tags in the `buffer`", do: true

    test "returns empty string when `buffer` is empty string" do
      assert Hsel.modify("", "") == {:ok, ""}
      assert Hsel.modify("", "p") == {:ok, ""}
    end

    test "targets top level elements", %{html: html} do
      assert Hsel.modify(html, "p") ==
        {:ok, "<p class=\"first desc\">\n  Foo bar\n</p><p class=\"deets\">\n  John Doe\n</p>"}
    end

    test "ignores elements that don't exist", %{html: html} do
      assert Hsel.modify(html, "tbody") == {:ok, ""}
    end

    test "targets elements by class", %{html: html} do
      assert Hsel.modify(html, ".item") == {:ok, "<td class=\"item\">Book</td>"}
    end

    test "does not 'encode' characters (i.e., the '>')", %{html: html} do
      assert Hsel.modify(html, "h1") == {:ok, "<h1>2 > 1</h1>"}
    end

    test "targets nested elements", %{html: html} do
      assert Hsel.modify(html, "#second td.desc") == {:ok, "<td class=\"desc\">A great read!</td>"}
    end

    test "targets lists of elements", %{html: html} do
      assert Hsel.modify(html, ".item, .deets") ==
        {:ok, "<td class=\"item\">Book</td><p class=\"deets\">\n  John Doe\n</p>"}
    end
  end
end
