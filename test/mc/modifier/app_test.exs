defmodule Mc.Modifier.AppTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.App

  setup do
    start_supervised({Memory, map: %{
      "app1" => "script1",
      "app3" => "script3\nscript5",
      "app5" => "script3",
      "app7" => "script7",
      "script1" => "lcase",
      "script3" => "r a ::1",
      "script5" => "r b ::2",
      "script7" => "b 1 => ::1, 2 => ::2, all => :::"
    }})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.App.modify/2" do
    test "builds an 'app script' given an 'app key' and 'replacements' and runs it against the `buffer`" do
      assert App.modify("DOT COM", "app1") == {:ok, "dot com"}
      assert App.modify("a b c", "app3 one two") == {:ok, "one two c"}
      assert App.modify("abba", "app5 ^") == {:ok, "^bb^"}
      assert App.modify("FOOBAR", "app1 no.replacements.for.this.app") == {:ok, "foobar"}
      assert App.modify("n/a", "app7 yab dab do") == {:ok, "1 => yab, 2 => dab, all => yab dab do"}
    end

    test "returns the 'app script' only ('script' switch)" do
      assert App.modify("n/a", "--script app1") == {:ok, "lcase"}
      assert App.modify("", "-s app1") == {:ok, "lcase"}
      assert App.modify("", "-s app3") == {:ok, "r a ::1\nr b ::2"}
    end

    test "replaces placeholders: '::1' => '1st arg', '::2' => '2nd arg', etc. ('script' switch)" do
      assert App.modify("", "-s app3 un deux") == {:ok, "r a un\nr b deux"}
      assert App.modify("", "-s app5 cash") == {:ok, "r a cash"}
      assert App.modify("", "-s app1 no.replacements.in.this.app") == {:ok, "lcase"}
    end

    test "replaces the 'all args' placeholder: ':::' => 'all args' ('script' switch)" do
      assert App.modify("", "-s app7 uno dos") == {:ok, "b 1 => uno, 2 => dos, all => uno dos"}
    end

    test "returns emtpy string when no 'app key' is given" do
      assert App.modify("", "") == {:ok, ""}
      assert App.modify("", "--script") == {:ok, ""}
      assert App.modify("", "-s") == {:ok, ""}
    end

    test "returns a help message" do
      assert Check.has_help?(App, :modify)
    end

    test "errors with unknown switches" do
      assert App.modify("n/a", "--unknown") == {:error, "Mc.Modifier.App#modify: switch parse error"}
      assert App.modify("", "-u") == {:error, "Mc.Modifier.App#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert App.modify({:ok, "BIG"}, "app1") == {:ok, "big"}
    end

    test "allows error tuples to pass through" do
      assert App.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
