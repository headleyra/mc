defmodule Mc.HttpTest do
  use ExUnit.Case, async: true
  alias Mc.Http

  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.10 Safari/605.1.1"

  describe "request/1" do
    test "returns a base (standard) Req request, given a URL" do
      req =  Http.request("http://example.org")
      assert %URI{scheme: "http", host: "example.org", port: 80} = req.url
      assert %{"user-agent" => [@user_agent], "timeout" => ["40000"]} = req.headers
    end
  end

  describe "decode/1" do
    test "decodes a Req response" do
      assert Http.decode({:ok, %Req.Response{status: 404}}) == {:error, "http 404"}
      assert Http.decode({:ok, %Req.Response{body: "foo bar"}}) == {:ok, "foo bar"}
      assert Http.decode({:error, %Req.TransportError{reason: :nxdomain}}) == {:error, "bad domain"}
    end

    test "decodes an unknown error tuple into a 'stringy' equivalent" do
      assert Http.decode({:error, %{random: 5}}) == {:error, "%{random: 5}"}
      assert Http.decode({:error, {"foo", :bar}}) == {:error, ~s({"foo", :bar})}
    end
  end
end
