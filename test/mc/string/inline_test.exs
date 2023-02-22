defmodule Mc.String.InlineTest do
  use ExUnit.Case, async: true
  alias Mc.String.Inline

  describe "decode/1" do
    test "echoes 'normal' text" do
      assert Inline.decode("foo") == {:ok, "foo"}
      assert Inline.decode("bish\nbosh") == {:ok, "bish\nbosh"}
      assert Inline.decode("nothing to see here") == {:ok, "nothing to see here"}
    end

    test "splits its input on semicolon-space" do
      assert Inline.decode("split; into; lines") == {:ok, "split\ninto\nlines"}
      assert Inline.decode("won't split into;lines") == {:ok, "won't split into;lines"}
      assert Inline.decode("big; tune; ") == {:ok, "big\ntune\n"}
      assert Inline.decode("; un; deux") == {:ok, "\nun\ndeux"}
      assert Inline.decode("foo %") == {:ok, "foo %"}
    end

    test "expands URI-encoded strings" do
      assert Inline.decode("nl:%0a, tb:%09, sp:%20, bt:%60") == {:ok, "nl:\n, tb:\t, sp: , bt:`"}
    end
  end
end
