defmodule Mc.Modifier.VersionTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Version

  def current_version do
    Mc.MixProject.project()[:version]
  end

  describe "Mc.Modifier.Version.modify/2" do
    test "returns the current version of Mc" do
      assert Version.modify("n/a", "n/a") == {:ok, current_version()}
    end

    test "works with ok tuples" do
      assert Version.modify({:ok, "BEST\nOF 3"}, "n/a") == {:ok, current_version()}
    end

    test "allows error tuples to pass-through" do
      assert Version.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
