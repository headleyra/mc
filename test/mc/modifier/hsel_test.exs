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
    test "uses `args` as a CSS selector targeting HTML content in the `buffer`" do
      assert true
    end

    test "returns empty string when `buffer` is empty string" do
      assert Hsel.modify("", "") == {:ok, ""}
      assert Hsel.modify("", "p") == {:ok, ""}
    end

    test "targets top level elements", %{html: html} do
      assert Hsel.modify(html, "p") == {:ok,
      """
      <p class="first desc">
        Foo bar
      </p><p class="deets">
        John Doe
      </p>
      """ |> String.trim_trailing()
      }
    end

    test "targets embedded elements", %{html: html} do
      assert Hsel.modify(html, "table") == {:ok, """
      <table><tr><td>Lorem ipsum</td></tr><tr><td>The quick fox</td></tr></table><table><tr><td class="item">Book</td></tr><tr><td class="desc">A great read!</td></tr></table>
      """ |> String.trim_trailing()
      }
    end

    test "ignores elements that don't exist", %{html: html} do
      assert Hsel.modify(html, "tbody") == {:ok, ""}
    end

    test "targets elements", %{html: html} do
      assert Hsel.modify(html, ".item") == {:ok, "<td class=\"item\">Book</td>"}
    end

    test "does not 'encode' characters", %{html: html} do
      assert Hsel.modify(html, "h1") == {:ok, "<h1>2 > 1</h1>"}
    end

    test "targets nested elements", %{html: html} do
      assert Hsel.modify(html, "#second td.desc") == {:ok, "<td class=\"desc\">A great read!</td>"}
    end

    test "targets lists of elements", %{html: html} do
      assert Hsel.modify(html, ".desc, .deets") == {:ok, """
      <p class="first desc">
        Foo bar
      </p><td class="desc">A great read!</td><p class="deets">
        John Doe
      </p>
      """ |> String.trim_trailing()
      }
    end

    test "works with ok tuples", %{html: html} do
      assert Hsel.modify({:ok, html}, ".item") == {:ok, "<td class=\"item\">Book</td>"}
    end

    test "allows error tuples to pass-through" do
      assert Hsel.modify({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end
end
