defmodule Mc.FieldTest do
  use ExUnit.Case, async: true
  alias Mc.Field

  describe "parse/4" do
    test "parses `args` as: <sep> <select spec><sep> <separator><sep> <joiner>", do: true
    test "see Mc.Select.parse/1", do: true

    test "separates, selects and joins" do
      assert Field.parse("foo.bar.biz", "1,3", ".", "-") == {:ok, "foo-biz"}
    end

    test "works with URI-encoded separators and joiners" do
      assert Field.parse("one\ntwo\nthree", "1-3,2,1", "%0a", "%20") == {:ok, "one two three two one"}
    end

    test "errors with a bad 'select spec'" do
      assert Field.parse("integers.only.please", "foo", ".", "-") == {:error, :bad_spec}
    end
  end
end
