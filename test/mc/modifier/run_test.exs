defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Run

  defmodule Mappings do
    defstruct [
      buffer: {Mc.Modifier.Buffer, :modify},
      lcase: {Mc.Modifier.Lcase, :modify},
      replace: {Mc.Modifier.Replace, :modify}
    ]
  end

  describe "modify/3" do
    test "treats `buffer` as a script and 'runs' it" do
      assert Run.modify("buffer FOO\nlcase", "", %Mappings{}) == {:ok, "foo"}
      assert Run.modify("buffer BAR\nlcase", "n/a", %Mappings{}) == {:ok, "bar"}
    end

    test "works with ok tuples" do
      assert Run.modify({:ok, "buffer Look\nreplace L B"}, "", %Mappings{}) == {:ok, "Book"}
    end

    test "allows error tuples to pass through" do
      assert Run.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
