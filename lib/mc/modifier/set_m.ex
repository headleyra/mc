defmodule Mc.Modifier.SetM do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.KvMultiple.set(buffer, args, mappings) do
      {:ok, result} ->
        {:ok, result}

      {:error, "bad format"} ->
        oops("bad format")
    end
  end
end
