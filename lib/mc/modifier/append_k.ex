defmodule Mc.Modifier.AppendK do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, buffer <> data}

      {:error, _reason} ->
        {:ok, buffer}
    end
  end
end
