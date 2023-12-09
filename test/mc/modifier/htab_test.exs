defmodule Mc.Modifier.HtabTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Htab

  setup do
    %{
      html_whitespace: """
      <div>
        <p>p0\n\n\t</p>
      </div>
      <div id="one">
        <p>\t\n  p1\n\n\t </p>
        <p>\t    \n\n\  p2\t\t\t</p>
      </div>
      <div id="two">
        <p>\t\n  p3\n\n\t </p>
        <p>\t  \t  \n\     p4  \t\t\t</p>
      </div>
      """,

      html: """
      <table summary="Changes between Earth and Neptune" class="galaxy">
      <thead>
        <tr class="">
          <th>Leaving</th>
          <th>From</th>
          <th>To</th>
          <th>Arriving</th>
        </tr>
      </thead>

      <tbody>
        <tr class="alt">
          <td>08:44</td>
          <td class="origin rocket-shop">Earth [<abbr>ERT</abbr>]</td>
          <td class="destination rocket-shop"><span class="arrow"><img class="sprite-main">Mars [<abbr>MRS</abbr>]</span></td>
          <td>08:53</td>
        </tr>

        <tr class="">
          <td>09:03</td>
          <td class="origin">Mars [<abbr>MRS</abbr>]</td>
          <td class="destination"><span class="arrow"><img class="sprite-main">Jupiter [<abbr>JUP</abbr>]</span></td>
          <td>09:26</td>
        </tr>

        <tr class="alt">
          <td>09:43</td>
          <td class="origin">Jupiter [<abbr>JUP</abbr>]</td>
          <td class="destination space-cinema"><span class="arrow"><img class="sprite-main">Neptune [<abbr>NEP</abbr>]</span></td>
          <td>11:04</td>
        </tr>
      </tbody>
      </table>
      """
    }
  end

  describe "modify/3" do
    test "tabulates `buffer` (expected to be HTML) given two (URI encoded) CSS selectors", do: assert true

    test "returns a table", %{html: html} do
      assert Htab.modify(html, "tr.alt td", %{}) ==
        {:ok, "08:44\tEarth [ERT]\tMars [MRS]\t08:53\n09:43\tJupiter [JUP]\tNeptune [NEP]\t11:04"}

      assert Htab.modify(html, "tr th", %{}) == {:ok, "Leaving\tFrom\tTo\tArriving"}
      assert Htab.modify(html, "tr abbr", %{}) == {:ok, "ERT\tMRS\nMRS\tJUP\nJUP\tNEP"}
    end

    test "returns a table (given URI encoded CSS selectors)", %{html: html} do
      assert Htab.modify(html, "table%20tbody%20tr td.origin%20abbr", %{}) == {:ok, "ERT\nMRS\nJUP"}
    end

    test "returns a table (where the CSS selectors target lists of elements)", %{html: html} do
      assert Htab.modify(html, "tr.alt,thead td.rocket-shop,td.space-cinema,th", %{}) ==
        {:ok, "Leaving\tFrom\tTo\tArriving\nEarth [ERT]\tMars [MRS]\nNeptune [NEP]"}
    end

    test "returns a table after removing whitespace around content", %{html_whitespace: html_whitespace} do
      assert Htab.modify(html_whitespace, "#one,#two p", %{}) == {:ok, "p1\tp2\np3\tp4"}
    end

    test "errors unless there are exactly 2 selectors", %{html: html} do
      assert Htab.modify(html, "", %{}) == {:error, "Mc.Modifier.Htab#modify: CSS selector parse error"}
      assert Htab.modify(html, "p", %{}) == {:error, "Mc.Modifier.Htab#modify: CSS selector parse error"}
      assert Htab.modify(html, "table tr td", %{}) == {:error, "Mc.Modifier.Htab#modify: CSS selector parse error"}
    end

    test "works with ok tuples", %{html: html} do
      assert Htab.modify({:ok, html}, "tr:nth-of-type(2) td", %{}) == {:ok, "09:03\tMars [MRS]\tJupiter [JUP]\t09:26"}
    end

    test "allows error tuples to pass through" do
      assert Htab.modify({:error, "some reason"}, "", %{}) == {:error, "some reason"}
    end
  end
end
