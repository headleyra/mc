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

  describe "Mc.Modifier.Hsel.modify/2" do
    test "uses `args` as a CSS selector targeting HTML content in the `buffer`", do: true

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

    test "returns content without tags ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "--content p") == {:ok, "Foo bar\nJohn Doe"}
      assert Hsel.modify(html, "-c p") == {:ok, "Foo bar\nJohn Doe"}
    end

    test "returns empty string when `buffer` is empty string ('content' switch)" do
      assert Hsel.modify("", "-c") == {:ok, ""}
      assert Hsel.modify("", "-c p") == {:ok, ""}
    end

    test "targets embedded elements ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "-c table") == {:ok, "Lorem ipsum The quick fox\nBook A great read!"}
    end

    test "ignores elements that don't exist ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "-c tbody") == {:ok, ""}
    end

    test "targets elements ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "-c .item") == {:ok, "Book"}
    end

    test "targets nested elements ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "-c #second td.desc") == {:ok, "A great read!"}
    end

    test "targets lists of elements ('content' switch)", %{html: html} do
      assert Hsel.modify(html, "-c .desc, .deets") == {:ok, "Foo bar\nA great read!\nJohn Doe"}
    end

    test "returns a help message" do
      assert Check.has_help?(Hsel, :modify)
    end

    test "errors with unknown switches" do
      assert Hsel.modify("", "--unknown") == {:error, "Mc.Modifier.Hsel#modify: switch parse error"}
      assert Hsel.modify("", "-u") == {:error, "Mc.Modifier.Hsel#modify: switch parse error"}
    end

    test "works with ok tuples", %{html: html} do
      assert Hsel.modify({:ok, html}, ".item") == {:ok, "<td class=\"item\">Book</td>"}
      assert Hsel.modify({:ok, html}, "-c .item") == {:ok, "Book"}
    end

    test "allows error tuples to pass through" do
      assert Hsel.modify({:error, "reason"}, "") == {:error, "reason"}
      assert Hsel.modify({:error, "reason"}, "-c") == {:error, "reason"}
    end
  end
end
