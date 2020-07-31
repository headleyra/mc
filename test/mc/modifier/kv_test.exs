defmodule Mc.Modifier.KvTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Kv

  setup do
    start_supervised({Kv, %{
      "1st" => "foo",
      "2nd" => "foobar",
      "3rd" => "dosh"
    }})
    :ok
  end

  describe "Mc.Modifier.Kv.state/0" do
    test "returns the initial state" do
      assert Kv.state() == %{
        "1st" => "foo",
        "2nd" => "foobar",
        "3rd" => "dosh"
      }
    end
  end

  describe "Mc.Modifier.Kv.set/2" do
    test "requests that the `buffer` is stored under 'key' (i.e. `args`)" do
      assert Kv.set("random data", "_rnd") == {:ok, "random data"}
      assert Kv.set("stuff", "_") == {:ok, "stuff"}
    end

    test "returns an error tuple when a 'readonly' key (one that doesn't start with underscore) is used" do
      assert Kv.set("foo", "a.key") == {:error, "Set: not allowed: a.key"}
      assert Kv.set("bar", "*system.key") == {:error, "Set: not allowed: *system.key"}
    end

    test "works with ok tuples" do
      assert Kv.set({:ok, "big tune"}, "_yeah") == {:ok, "big tune"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Kv.set({:error, "reason"}, "_n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.set!/2" do
    test "requests that the `buffer` is stored under 'key' (i.e. `args`)" do
      assert Kv.set!("random data", "_dosh") == {:ok, "random data"}
      assert Kv.set!("stuff", "_foo") == {:ok, "stuff"}
    end

    test "sets all keys, even readonly ones" do
      assert Kv.set!("oh", "normal.readonly.key") == {:ok, "oh"}
      assert Kv.set!("bar", "*system.key") == {:ok, "bar"}
      assert Kv.set!("weekend", "_writeable.key") == {:ok, "weekend"}
    end

    test "works with ok tuples" do
      assert Kv.set!({:ok, "treble"}, "yeah") == {:ok, "treble"}
      assert Kv.set!({:ok, "bass"}, "_yeah") == {:ok, "bass"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Kv.set!({:error, "reason"}, "n/a") == {:error, "reason"}
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

    test "allows error tuples to pass-through unchanged" do
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

    test "allows error tuples to pass-through unchanged" do
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

    test "allows error tuples to pass-through unchanged" do
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

    test "returns an error tuple when the regex is bad" do
      assert Kv.findk("one\ntwo", "?") == {:error, "Findk: bad regex"}
    end

    test "works with ok tuples" do
      assert Kv.findk({:ok, "n/a"}, "3") == {:ok, "3rd"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Kv.findk({:error, "reason"}, "key") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.findv/2" do
    test "filters on value given a regex and returns corresponding keys" do
      assert Kv.findv("n/a", "dos") == {:ok, "3rd"}
      assert Kv.findv("n/a", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Kv.findv("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "returns an error tuple when the regex is bad" do
      assert Kv.findv("one\ntwo", "*") == {:error, "Findv: bad regex"}
    end

    test "works with ok tuples" do
      assert Kv.findv({:ok, "n/a"}, ".") == {:ok, "1st\n2nd\n3rd"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Kv.findv({:error, "reason"}, "key") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Kv.find/1" do
    test "filters keys/values with a function of form `fn({key, value}) -> ... end` returning corresponding keys" do
      foo = fn({_key, value}) -> Regex.match?(~r/foo/, value) end
      assert Kv.find(foo) == {:ok, "1st\n2nd"}

      other = fn({_key, value}) -> value == "dosh" end
      assert Kv.find(other) == {:ok, "3rd"}

      bar = fn({key, _value}) -> Regex.match?(~r/d/, key) end
      assert Kv.find(bar) == {:ok, "2nd\n3rd"}
    end
  end
end
