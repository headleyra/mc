defmodule Mc.Modifier.PrependK do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.modify("", "get #{args}", mappings) do
      {:ok, data} ->
        {:ok, data <> buffer}

      {:error, _reason} ->
        {:ok, buffer}
    end
  end
end
