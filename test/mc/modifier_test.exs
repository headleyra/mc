defmodule Mc.ModifierTest do
  use ExUnit.Case, async: true

  defmodule Mod do
    use Mc.Modifier

    @impl Mc.Behaviour.Modifier
    def m(buffer, args, mappings) do
      map = inspect(mappings)
      result = "#{buffer} #{args} #{map}"
      {:ok, result}
    end
  end

  describe "use Mc.Modifier" do
    test "injects the `Mc.Behaviour.Modifier` behaviour", do: true

    test "creates a m/3 function that allows error-tuples to pass through" do
      assert Mod.m({:error, Foo, :bar, "oops", []}, "", %{}) == {:error, Foo, :bar, "oops", []}
      assert Mod.m({:error, Biz, :niz, "boom", []}, "", %{}) == {:error, Biz, :niz, "boom", []}
    end

    test "creates a m/3 function to handle ok-tuples" do
      assert Mod.m({:ok, "foo"}, "::", %{bar: 1}) == {:ok, "foo :: %{bar: 1}"}
      assert Mod.m({:ok, "dar\nordar"}, "<>", %{}) == {:ok, "dar\nordar <> %{}"}
    end

    test "creates an oops/2 function that returns an error-tuple" do
      assert Mod.oops(:fuel, "low") == {:error, Mc.ModifierTest.Mod, :fuel, "low", []}
    end

    test "creates an oops/3 function that returns a 'stacked' error-tuple" do
      error = {:error, E1, :e1, "e1", []}
      assert Mod.oops(:e2, "e2", error) == {:error, Mc.ModifierTest.Mod, :e2, "e2", [{E1, :e1, "e1"}]}

      error = {:error, E2, :e2, "e2", [{E1, :e1, "e1"}]}
      assert Mod.oops(:e3, "e3", error) == {:error, Mc.ModifierTest.Mod, :e3, "e3", [{E2, :e2, "e2"}, {E1, :e1, "e1"}]}

      ok = {:ok, "some result"}
      assert Mod.oops(ok, :e2, "e2") == {:ok, "some result"}

      error = {:error, E1, :e1, "e1", []}
      assert Mod.oops(error, :e2, "e2") == {:error, Mc.ModifierTest.Mod, :e2, "e2", [{E1, :e1, "e1"}]}

      error = {:error, E2, :e2, "e2", [{E1, :e1, "e1"}]}
      assert Mod.oops(error, :e3, "e3") == {:error, Mc.ModifierTest.Mod, :e3, "e3", [{E2, :e2, "e2"}, {E1, :e1, "e1"}]}
    end
  end
end
