defmodule Mc.Test.HttpAdapter do
  @behaviour Mc.Behaviour.HttpAdapter

  def get(url), do: {:ok, url}
  def post(url, params), do: {:ok, {url, params}}
end
