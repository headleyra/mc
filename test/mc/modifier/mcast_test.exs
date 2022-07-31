defmodule Mc.Modifier.McastTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv
  alias Mc.Modifier.Get
  alias Mc.Modifier.Mcast

  setup do
    start_supervised({Kv, map: %{
      "s1" => "buffer buffer FOO; lcase\nrun",
      "s2" => "buffer buffer Explain rice; delete Ex\nrun",
      "s3" => "error boom!\nlcase",
      "script.indirection.key" => "s1 s3",
      "sk1" => "s3 s2",
      "sk2" => "nah s2",
      "empty.keys" => "",
      "nokeys" => "oops\tnope"
    }})
    start_supervised({Get, kv_client: Kv})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Mcast.modify/2" do
    test "runs the scripts referenced by the keys in `args` and returns a list of the results" do
      assert Mcast.modify("n/a", "s1") == {:ok, "s1: ok: foo"}
      assert Mcast.modify("", "s1 s2") == {:ok, "s1: ok: foo\ns2: ok: plain rice"}
      assert Mcast.modify("", "s3 s2") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
      assert Mcast.modify("", "s2 noexist") == {:ok, "s2: ok: plain rice\nnoexist: ok: "}
    end

    test "returns empty string when `args` is empty" do
      assert Mcast.modify("tumble weed", "") == {:ok, ""}
    end

    test "runs the scripts indirectly referenced by the key ('key' switch)" do
      assert Mcast.modify("n/a", "--key script.indirection.key") == {:ok, "s1: ok: foo\ns3: error: boom!"}
      assert Mcast.modify("", "-k sk1") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
      assert Mcast.modify("", "-k sk2") == {:ok, "nah: ok: \ns2: ok: plain rice"}
    end

    test "errors when no key is given ('key' switch)" do
      assert Mcast.modify("", "--key") == {:error, "Mc.Modifier.Mcast#modify: switch parse error"}
      assert Mcast.modify("", "-k") == {:error, "Mc.Modifier.Mcast#modify: switch parse error"}
    end

    test "returns a help message" do
      assert Check.has_help?(Mcast, :modify)
    end

    test "errors with unknown switches" do
      assert Mcast.modify("", "--unknown") == {:error, "Mc.Modifier.Mcast#modify: switch parse error"}
      assert Mcast.modify("", "-u") == {:error, "Mc.Modifier.Mcast#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Mcast.modify({:ok, ""}, "-k sk1") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
      assert Mcast.modify({:ok, "n/a"}, "s3 s2") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
    end

    test "allows error tuples to pass through" do
      assert Mcast.modify({:error, "reason"}, "") == {:error, "reason"}
      assert Mcast.modify({:error, "reason"}, "-k na") == {:error, "reason"}
    end
  end
end
