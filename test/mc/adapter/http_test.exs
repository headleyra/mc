defmodule Mc.Adapter.HttpTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.Http

  @moduletag :external

  @schemes ~w[http https]
  @schemes_bad ~w[ftp sftp foo telnet]
  @urls_bad ~w[example //example.net /example.org example.com]

  describe "get/1" do
    test "gets a URL" do
      Enum.each(@schemes, fn scheme ->
        get_check("#{scheme}://example.org", "<!doctype html>")
      end)
    end

    test "errors with schemes that are not supported" do
      Enum.each(@schemes_bad, fn scheme ->
        get_check("#{scheme}://www.example.net", {:error, "scheme not supported"})
      end)
    end

    test "errors with bad URLs" do
      Enum.each(@urls_bad, fn url ->
        get_check(url, {:error, "missing scheme"})
      end)

      assert Http.get("https://exam<ple.net") == {:error, "bad domain"}
    end
  end

  describe "post/2" do
    test "posts to a URL (with a list of params)" do
      test_data = [
        {"http", [], %{}},
        {"https", [pi: 3.142], %{"pi" => "3.142"}},
        {"https", [x: 123, y: -5], %{"x" => "123", "y" => "-5"}}
      ]

      Enum.each(test_data, fn {scheme, params_list, expected} ->
        post_check("#{scheme}://httpbin.org/post", params_list, expected)
      end)
    end

    test "errors with schemes that are not supported" do
      Enum.each(@schemes_bad, fn scheme ->
        post_check("#{scheme}://httpbin.org/post", [], {:error, "scheme not supported"})
      end)
    end

    test "errors with bad URLs" do
      Enum.each(@urls_bad, fn url ->
        post_check(url, [], {:error, "missing scheme"})
      end)

      assert Http.post("https://exam<ple.net", []) == {:error, "bad domain"}
    end
  end

  defp get_check(url, expected) do
    response = Http.get(url)

    if is_binary(expected) do
      {:ok, html} = response
      assert String.starts_with?(html, expected)
    else
      assert response == expected
    end
  end

  defp post_check(url, params_list, expected) do
    response = Http.post(url, params_list)

    if is_map(expected) do
      {:ok, json} = response
      {:ok, map} = Jason.decode(json)
      assert map["form"] == expected
    else
      assert response == expected
    end
  end
end
