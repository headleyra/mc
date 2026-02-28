defmodule Mc.Modifier.Select do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.Modifier.Field.modify(buffer, "#{args} %0a %0a", mappings) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason} ->
        oops(reason)
    end
  end
end
