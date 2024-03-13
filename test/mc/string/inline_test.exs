defmodule Mc.String.InlineTest do
  use ExUnit.Case, async: true
  alias Mc.String.Inline

  describe "decode/1" do
    test "echoes 'normal' text" do
      assert Inline.decode("foo") == "foo"
      assert Inline.decode("bish\nbosh") == "bish\nbosh"
      assert Inline.decode("nothing to see here") == "nothing to see here"
    end

    test "splits its input on semicolon-space" do
      assert Inline.decode("split; into; lines") == "split\ninto\nlines"
      assert Inline.decode("won't split into;lines") == "won't split into;lines"
      assert Inline.decode("big; tune; ") == "big\ntune\n"
      assert Inline.decode("; un; deux") == "\nun\ndeux"
      assert Inline.decode("foo %") == "foo %"
    end
  end
end
