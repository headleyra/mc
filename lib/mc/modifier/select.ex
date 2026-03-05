defmodule Mc.Modifier.Select do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case Mc.Modifier.Field.m(buffer, "#{args} %0a %0a", mappings) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason} ->
        oops(reason)
    end
  end
end
