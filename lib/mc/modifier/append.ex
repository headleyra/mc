defmodule Mc.Modifier.Append do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    try do
      result = buffer <> Mc.Util.Sys.decode(args)
      {:ok, result}
    rescue
      ArgumentError ->
        {:error, "Append: bad URI"}
    end
  end
end
