defmodule Mc.Util.SysTest do
  use ExUnit.Case, async: true
  alias Mc.Util.Sys

  describe "Mc.Util.Sys.decode/1" do
    test "decodes `string` ('inline args' format)" do
      assert Sys.decode("split; into; lines") == "split\ninto\nlines"
      assert Sys.decode("won't split into;lines") == "won't split into;lines"
      assert Sys.decode("big; tune; ") == "big\ntune\n"
      assert Sys.decode("un\ndeux; trois; ") == "un\ndeux\ntrois\n"
    end

    test "accepts a URI encoded `string`" do
      assert Sys.decode("%0a%09stuff%20to; decode 100%25") == "\n\tstuff to\ndecode 100%"
    end

    test "returns an error tuple given a string containing malformed URI" do
      assert Sys.decode("foo %") == {:error, ""}
    end
  end

  describe "Mc.Util.Sys.writeable_key?/1" do
    test "returns true for writeable KV key names (keys that start with underscore)" do
      assert Sys.writeable_key?("_foo")
      assert Sys.writeable_key?("_")
      assert Sys.writeable_key?("__")
      assert Sys.writeable_key?("__key")
    end

    test "returns false for readonly KV key strings" do
      refute Sys.writeable_key?("a.key")
      refute Sys.writeable_key?("")
      refute Sys.writeable_key?("*_b")
      refute Sys.writeable_key?("+")
    end
  end
end
