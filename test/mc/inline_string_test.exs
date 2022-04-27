defmodule Mc.InlineStringTest do
  use ExUnit.Case, async: true
  alias Mc.InlineString

  describe "Mc.InlineString.decode/1" do
    test "inline decodes `string`" do
      assert InlineString.decode("split; into; lines") == {:ok, "split\ninto\nlines"}
      assert InlineString.decode("won't split into;lines") == {:ok, "won't split into;lines"}
      assert InlineString.decode("big; tune; ") == {:ok, "big\ntune\n"}
      assert InlineString.decode("un\ndeux; trois; ") == {:ok, "un\ndeux\ntrois\n"}
      assert InlineString.decode("foo %") == {:ok, "foo %"}
    end

    test "accepts a URI encoded `string`" do
      assert InlineString.decode("%0a%09stuff%20to; decode 100%25") == {:ok, "\n\tstuff to\ndecode 100%"}
    end
  end

  describe "Mc.InlineString.uri_decode/1" do
    test "URI decodes `string`" do
      assert InlineString.uri_decode("%0a") == {:ok, "\n"}
      assert InlineString.uri_decode("%20") == {:ok, " "}
      assert InlineString.uri_decode("tab: %09") == {:ok, "tab: \t"}
      assert InlineString.uri_decode("percentage: %25") == {:ok, "percentage: %"}
      assert InlineString.uri_decode("%") == {:ok, "%"}
      assert InlineString.uri_decode("%e") == {:ok, "%e"}
      assert InlineString.uri_decode("ok: %0a, oops: %%") == {:ok, "ok: \n, oops: %%"}
    end
  end
end
