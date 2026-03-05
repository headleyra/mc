defmodule Mc.Modifier.PrependK do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.m("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, data <> buffer}

      {:error, _reason} ->
        {:ok, buffer}
    end
  end
end
