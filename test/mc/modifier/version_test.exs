defmodule Mc.Modifier.VersionTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Version

  def current_version do
    Mc.MixProject.project()[:version]
  end

  describe "m/3" do
    test "returns the system version" do
      assert Version.m("", "", %{}) == {:ok, current_version()}
    end

    test "works with ok tuples" do
      assert Version.m({:ok, "BEST\nOF 3"}, "", %{}) == {:ok, current_version()}
    end

    test "allows error tuples to pass through" do
      assert Version.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
