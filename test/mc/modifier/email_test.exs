defmodule Mc.Modifier.EmailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Email

  describe "m/3" do
    test "parses `args` as a subject and recipient list", do: true

    test "sends `buffer` as the body of an email by calling `deliver` on the 'email adapter'" do
      assert Email.m("a message", "a subject, ale@example.net beer@example.org", %{}) ==
        {:ok, {"a subject", "a message", ["ale@example.net", "beer@example.org"]}}
    end

    test "wraps errors returned from the email adapter" do
      assert Email.m("", "trigger-error, i@example.com", %{}) == {:error, Mc.Modifier.Email, :adapter_error, nil, []}
    end

    test "errors when subject and/or recipient(s) are missing" do
      assert Email.m("hi", "subj", %{}) == {:error, Mc.Modifier.Email, :missing_subject_recipients, "subj", []}
      assert Email.m("hi", "", %{}) == {:error, Mc.Modifier.Email, :missing_subject_recipients, "", []}
    end

    test "works with ok-tuples" do
      assert Email.m({:ok, "a great read"}, "that book, a@example.org", %{}) ==
        {:ok, {"that book", "a great read", ["a@example.org"]}}
    end

    test "allows error-tuples to pass through" do
      assert Email.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
