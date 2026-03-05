defmodule Mc.Modifier.AppendK do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.m("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, buffer <> data}

      {:error, _reason} ->
        {:ok, buffer}
    end
  end
end
