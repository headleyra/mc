defmodule Mc.ModifierTest do
  use ExUnit.Case, async: true

  defmodule Mod do
    use Mc.Modifier

    @impl Mc.Behaviour.Modifier
    def modify(buffer, _args, _mappings) do
      {:ok, String.downcase(buffer)}
    end
  end

  describe "use Mc.Modifier" do
    test "creates a modify/3 (short-circuit) function that returns error tuples unchanged" do
      assert Mod.modify({:error, "oops"}, "", %{}) == {:error, "oops"}
      assert Mod.modify({:error, "boom"}, "n/a", %{}) == {:error, "boom"}
    end

    test "creates a modify/3 function that delegates to the existing modify/3 function (for ok tuples)" do
      assert Mod.modify({:ok, "BOSH"}, "", %{}) == {:ok, "bosh"}
      assert Mod.modify({:ok, "DAr\nOrdaR"}, "", %{}) == {:ok, "dar\nordar"}
    end

    test "creates a 'name' function that returns the modifier module name" do
      assert Mod.name() == "Mc.ModifierTest.Mod"
    end

    test "creates a 'oops' function that generates an error tuple" do
      assert Mod.oops("kaboom") == {:error, "Mc.ModifierTest.Mod: kaboom"}
    end
  end
end
