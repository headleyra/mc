defmodule Mc.Modifier.McastTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Mcast

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{
      "script1" => "buffer buffer FOO; lcase\nrun",
      "s2" => "buffer buffer Explain rice; delete Ex\nrun",
      "s3" => "error boom!\nlcase",
      "script.indirection.key" => "script1 s3",
      "sk1" => "s3 s2",
      "sk2" => "nah s2",
      "empty.keys" => "",
      "nokeys" => "oops\tnope"
    }})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Mcast.modify/2" do
    test "runs the scripts referenced by the keys in `args` and returns a list of the results" do
      assert Mcast.modify("n/a", "script1") == {:ok, "script1: ok: foo"}
      assert Mcast.modify("", "script1 s2") == {:ok, "script1: ok: foo\ns2: ok: plain rice"}
      assert Mcast.modify("", "s3 s2") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
      assert Mcast.modify("", "s2 noexist") == {:ok, "s2: ok: plain rice\nnoexist: ok: "}
    end

    test "returns empty string when `args` is empty" do
      assert Mcast.modify("tumble weed", "") == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Mcast.modify({:ok, "n/a"}, "s3 s2") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Mcast.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Mcast.modifyk/2" do
    test "runs the scripts, indirectly, referenced by the key contained in `args` and returns a list of the results" do
      assert Mcast.modifyk("n/a", "script.indirection.key") == {:ok, "script1: ok: foo\ns3: error: boom!"}
      assert Mcast.modifyk("", "sk1") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
      assert Mcast.modifyk("", "sk2") == {:ok, "nah: ok: \ns2: ok: plain rice"}
    end

    test "returns empty string when `args` is empty" do
      assert Mcast.modifyk("", "empty.keys") == {:ok, ""}
      assert Mcast.modifyk("", "nokeys") == {:ok, "oops: ok: \nnope: ok: "}
      assert Mcast.modifyk("tumble weed", "") == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Mcast.modifyk({:ok, "n/a"}, "sk1") == {:ok, "s3: error: boom!\ns2: ok: plain rice"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Mcast.modifyk({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
