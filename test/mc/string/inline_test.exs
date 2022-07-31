defmodule Mc.String.InlineTest do
  use ExUnit.Case, async: true
  alias Mc.String.Inline

  describe "Mc.String.Inline.decode/1" do
    test "'inline' decodes its input" do
      assert Inline.decode("split; into; lines") == {:ok, "split\ninto\nlines"}
      assert Inline.decode("won't split into;lines") == {:ok, "won't split into;lines"}
      assert Inline.decode("big; tune; ") == {:ok, "big\ntune\n"}
      assert Inline.decode("un\ndeux; trois; ") == {:ok, "un\ndeux\ntrois\n"}
      assert Inline.decode("foo %") == {:ok, "foo %"}
    end

    test "accepts a URI encoded string" do
      assert Inline.decode("%0a%09stuff%20to; decode 100%25") == {:ok, "\n\tstuff to\ndecode 100%"}
    end
  end

  describe "Mc.String.Inline.uri_decode/1" do
    test "URI decodes its input" do
      assert Inline.uri_decode("%0a") == {:ok, "\n"}
      assert Inline.uri_decode("%20") == {:ok, " "}
      assert Inline.uri_decode("tab: %09") == {:ok, "tab: \t"}
      assert Inline.uri_decode("percentage: %25") == {:ok, "percentage: %"}
      assert Inline.uri_decode("%") == {:ok, "%"}
      assert Inline.uri_decode("%e") == {:ok, "%e"}
      assert Inline.uri_decode("ok: %0a, oops: %%") == {:ok, "ok: \n, oops: %%"}
    end
  end
end
