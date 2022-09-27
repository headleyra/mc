defmodule Mc.Modifier.IfTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.If

  setup do
    start_supervised({Memory, map: %{
      "compare" => "NOW",
      "true" => "lcase",
      "false" => "append festival",
      "nah" => "then"
    }})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.If.modify/2" do
    test "runs 'value of true' if `buffer` equals 'value of compare' else runs 'value of false'" do
      assert If.modify("NOW", "compare true false") == {:ok, "now"}
      assert If.modify("london bridge ", "nah true false") == {:ok, "london bridge festival"}
      assert If.modify("food ", "noexist true false") == {:ok, "food festival"}
    end

    test "errors without exactly 3 keys" do
      assert If.modify("fiscal rules", "") ==
        {:error, "Mc.Modifier.If#modify: parse error"}

      assert If.modify("foo bar", "one two") ==
        {:error, "Mc.Modifier.If#modify: parse error"}

      assert If.modify("gig economy", "one") ==
        {:error, "Mc.Modifier.If#modify: parse error"}

      assert If.modify("yaba daba do", "buy the dip dude") ==
        {:error, "Mc.Modifier.If#modify: parse error"}
    end

    test "works with ok tuples" do
      assert If.modify({:ok, "aaa "}, "compare true false") == {:ok, "aaa festival"}
    end

    test "allows error tuples to pass through" do
      assert If.modify({:error, "reason"}, "na") == {:error, "reason"}
    end
  end
end
