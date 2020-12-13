defmodule Mc.Modifier.KvTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Kv

  setup do
    start_supervised({Kv, map: %{
      "1st" => "foo",
      "2nd" => "foobar",
      "3rd" => "dosh"}
    })
    :ok
  end

  describe "Mc.Modifier.Kv.map/0" do
    test "returns the initial map" do
      assert Kv.map() == %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    end
  end

  describe "Mc.Modifier.Kv.set/2" do
    test "requests that the `buffer` is stored under 'key' (i.e. `args`)" do
      assert Kv.set("random data", "rand") == {:ok, "random data"}
      assert Kv.set("stuff", "_x") == {:ok, "stuff"}
    end

    test "works with ok tuples" do
      assert Kv.set({:ok, "big tune"}, "yeah") == {:ok, "big tune"}
    end

    test "allows error tuples to pass-through" do
      assert Kv.set({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.get/2" do
    test "retrieves the value stored under 'key' (i.e. `args`)" do
      Kv.set("some buffer", "_a-key")
      assert Kv.get("n/a", "_a-key") == {:ok, "some buffer"}
      assert Kv.get("foo", "key-no-exist") == {:ok, ""}
    end

    test "works with ok tuples" do
      Kv.set("dance", "_funky")
      assert Kv.get({:ok, "n/a"}, "_funky") == {:ok, "dance"}
      assert Kv.get({:ok, "n/a"}, "bop") == {:ok, ""}
    end

    test "allows error tuples to pass-through" do
      assert Kv.get({:error, "reason"}, "rose") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.appendk/2" do
    test "appends the 'value' associated with the 'key' (i.e. `args`), to the `buffer`" do
      Kv.set("bar", "_")
      assert Kv.appendk("raise the ", "_") == {:ok, "raise the bar"}
      assert Kv.appendk("raise the ", "nah") == {:ok, "raise the "}
    end

    test "works with ok tuples" do
      Kv.set("step", "_tune")
      assert Kv.appendk({:ok, "dub "}, "_tune") == {:ok, "dub step"}
      assert Kv.appendk({:ok, "dub "}, "foo") == {:ok, "dub "}
    end

    test "allows error tuples to pass-through" do
      assert Kv.appendk({:error, "reason"}, "key") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.prependk/2" do
    test "prepends the 'value' associated with the 'key' (i.e. `args`), to the `buffer`" do
      Kv.set("un", "_1")
      assert Kv.prependk(" deux trois", "_1") == {:ok, "un deux trois"}
      assert Kv.prependk("just this", "key-no-exist") == {:ok, "just this"}
    end

    test "works with ok tuples" do
      Kv.set("bi", "_2")
      assert Kv.prependk({:ok, "cycle"}, "_2") == {:ok, "bicycle"}
      assert Kv.prependk({:ok, "fast train"}, "key-no-exist") == {:ok, "fast train"}
    end

    test "allows error tuples to pass-through" do
      assert Kv.prependk({:error, "reason"}, "anykey") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.findk/2" do
    test "filters on key given a regex and returns corresponding keys" do
      assert Kv.findk("n/a", "rd") == {:ok, "3rd"}
      assert Kv.findk("", "d") == {:ok, "2nd\n3rd"}
      assert Kv.findk("", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Kv.findk("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Kv.findk("one\ntwo", "?") == {:error, "usage: findk <regex>"}
    end

    test "works with ok tuples" do
      assert Kv.findk({:ok, "n/a"}, "3") == {:ok, "3rd"}
    end

    test "allows error tuples to pass-through" do
      assert Kv.findk({:error, "reason"}, "key") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.findv/2" do
    test "filters on value given a regex and returns corresponding keys" do
      assert Kv.findv("n/a", "dos") == {:ok, "3rd"}
      assert Kv.findv("n/a", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Kv.findv("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Kv.findv("one\ntwo", "*") == {:error, "usage: findv <regex>"}
    end

    test "works with ok tuples" do
      assert Kv.findv({:ok, "n/a"}, ".") == {:ok, "1st\n2nd\n3rd"}
    end

    test "allows error tuples to pass-through" do
      assert Kv.findv({:error, "reason"}, "key") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.find/1" do
    test "filters keys/values with a func of form `fn {key, value} -> ... end` returning corresponding keys" do
      foo = fn {_key, value} -> Regex.match?(~r/foo/, value) end
      assert Kv.find(foo) == {:ok, "1st\n2nd"}

      other = fn {_key, value} -> value == "dosh" end
      assert Kv.find(other) == {:ok, "3rd"}

      bar = fn {key, _value} -> Regex.match?(~r/d/, key) end
      assert Kv.find(bar) == {:ok, "2nd\n3rd"}
    end
  end
end
