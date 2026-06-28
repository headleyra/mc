defmodule Mc.Modifier.UnknownTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Unknown

  describe "m/3" do
    test "returns an error-tuple to signal that a modifier is unknown", do: true

    test "uses `args` to specify the modifier's name" do
      assert Unknown.m("n/a", "foo", %{}) == {:error, Mc.Modifier.Unknown, :modifier_unknown, "foo", []}
      assert Unknown.m("", "bar", %{}) == {:error, Mc.Modifier.Unknown, :modifier_unknown, "bar", []}
    end
  end
end
