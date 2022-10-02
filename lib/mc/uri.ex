defmodule Mc.Uri do
  def decode(string) do
    {:ok, URI.decode(string)}
  end
end
