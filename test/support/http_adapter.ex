defmodule Mc.Test.HttpAdapter do
  @behaviour Mc.Behaviour.HttpAdapter

  def get("trigger-error"), do: {:error, "GET error"}
  def get(url), do: {:ok, url}

  def post("trigger-error", _params_list), do: {:error, "POST error"}
  def post(url, params_list), do: {:ok, {url, params_list}}
end
