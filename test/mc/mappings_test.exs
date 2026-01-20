defmodule Mc.McTest do
  use ExUnit.Case, async: true
  alias Mc.Mappings

  describe "standard/0" do
    test "defines modifiers that exist" do
      Mappings.standard()
      |> Map.values()
      |> Enum.each(fn module -> exists?(module) end)
    end
  end

  describe "s/0" do
    test "defines modifiers that exist" do
      Mappings.s()
      |> Map.values()
      |> Enum.each(fn module -> exists?(module) end)
    end
  end

  defp exists?(module) do
    Code.ensure_loaded(module)
    assert function_exported?(module, :modify, 3), "#{module} does not exist or is missing a modify/3 function"
  end
end
