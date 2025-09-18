defmodule Mc.TokenizerTest do
  use ExUnit.Case, async: true
  alias Mc.Tokenizer

  describe "parse/1" do
    test "returns a list with 'curly brace' tokens marked" do
      assert Tokenizer.parse("foo {bar}") == ["f", "o", "o", " ", {:token, ["b", "a", "r"]}]
      assert Tokenizer.parse("{a}{b}") == [{:token, ["a"]}, {:token, ["b"]}]
    end

    test "ignores braces that are not matched" do
      assert Tokenizer.parse("a b }}") == ["a", " ", "b", " ", "}", "}"]
      assert Tokenizer.parse("{ab} }") == [{:token, ["a", "b"]}, " ", "}"]
    end

    test "marks innermost tokens only" do
      assert Tokenizer.parse("{{ab}}") == ["{", {:token, ["a", "b"]}, "}"]
      assert Tokenizer.parse("{{{a b}}}") == ["{", "{", {:token, ["a", " ", "b"]}, "}", "}"]
    end
  end
end
