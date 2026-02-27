defmodule Mc.Modifier.ScriptTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Script

  setup do
    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "parses `args` as: <sep> <1st line of script>{<sep> <2nd line of script script>}", do: true

    test "runs the script", %{mappings: mappings} do
      assert Script.modify("", ", range 3, map prepend :, append -go", mappings) == {:ok, ":1\n:2\n:3-go"}
    end

    test "runs the script against `buffer`", %{mappings: mappings} do
      assert Script.modify("foo", "@ append -@ append bar", mappings) == {:ok, "foo-bar"}
    end

    test "works with URI-encoded separators", %{mappings: mappings} do
      assert Script.modify("bish", "%09 append -\t append bosh", mappings) == {:ok, "bish-bosh"}
    end

    test "returns script errors", %{mappings: mappings} do
      assert Script.modify("", "; b dosh; error cash", mappings) == {:error, "cash"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Script.modify({:ok, "123"}, "/ prepend 0/ append 4", mappings) == {:ok, "01234"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Script.modify({:error, "reason"}, ", buffer one, replace e 3", mappings) == {:error, "reason"}
    end
  end
end
