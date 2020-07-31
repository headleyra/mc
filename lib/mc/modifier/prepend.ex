defmodule Mc.Modifier.Prepend do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    try do
      result = Mc.Util.Sys.decode(args) <> buffer
      {:ok, result}
    rescue
      ArgumentError ->
        {:error, "Prepend: bad URI"}
    end
  end
end
