defmodule Mc.Modifier.LoginTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Login

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{}})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Login.modify/2" do
    test "'logs in' the given 'userid'" do
      assert Login.modify("some data", "techie") == {:ok, "some data"}
      assert Mc.modify("", "get !user") == {:ok, "techie"}
    end

    test "returns error tuple when 'userid' doesn't match ~r/^[a-z][a-z0-9]{1,15}$/" do
      bad_userids = [
        "",
        "007",
        "x",
        "no_under_scores",
        "no.dots",
        "no spaces",
        "a2345678901234567"
      ]

      Enum.each(bad_userids, fn uid ->
        assert Login.modify("n/a", uid) == {:error, "Login: bad userid"}
      end)
    end

    test "works with ok tuples" do
      assert Login.modify({:ok, "n/a"}, "assam") == {:ok, "n/a"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Login.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
