defmodule Mc.WebClientInterfaceTest do
  use ExUnit.Case, async: true

  defmodule Browser do
    use Mc.WebClientInterface
  end

  defmodule BrowserOverride do
    use Mc.WebClientInterface
    def get(url), do: {:overridden, url}
    def post(url, params), do: {:overridden, url, params}
  end

  describe "Mc.WebClientInterface" do
    test "defines default functions" do
      assert Browser.get("url") == {"url"}
      assert Browser.post("url", %{post: "params"}) == {"url", %{post: "params"}}
    end

    test "allows functions to be overridden" do
      assert BrowserOverride.get("url") == {:overridden, "url"}
      assert BrowserOverride.post("url", %{foo: "bar"}) == {:overridden, "url", %{foo: "bar"}}
    end
  end
end
