defmodule Mc.Util.InlineStringTest do
  use ExUnit.Case, async: true
  alias Mc.Util.InlineString

  describe "Mc.Util.InlineString.decode/1" do
    test "inline decodes `string`" do
      assert InlineString.decode("split; into; lines") == {:ok, "split\ninto\nlines"}
      assert InlineString.decode("won't split into;lines") == {:ok, "won't split into;lines"}
      assert InlineString.decode("big; tune; ") == {:ok, "big\ntune\n"}
      assert InlineString.decode("un\ndeux; trois; ") == {:ok, "un\ndeux\ntrois\n"}
    end

    test "accepts a URI encoded `string`" do
      assert InlineString.decode("%0a%09stuff%20to; decode 100%25") == {:ok, "\n\tstuff to\ndecode 100%"}
    end

    test "errors if `string` can't be parsed" do
      assert InlineString.decode("foo %") == :error
    end
  end

  describe "Mc.Util.InlineString.uri_decode/1" do
    test "URI decodes `string`" do
      assert InlineString.uri_decode("%0a") == {:ok, "\n"}
      assert InlineString.uri_decode("%20") == {:ok, " "}
      assert InlineString.uri_decode("tab: %09") == {:ok, "tab: \t"}
      assert InlineString.uri_decode("percentage: %25") == {:ok, "percentage: %"}
    end

    test "errors if `string` can't be parsed" do
      assert InlineString.uri_decode("%") == :error
      assert InlineString.uri_decode("%e") == :error
      assert InlineString.uri_decode("ok: %0a, oops: %%") == :error
    end
  end
end
