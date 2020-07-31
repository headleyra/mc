defmodule Mc.Modifier.Ccount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    result =
      String.length(buffer)
      |> Integer.to_string()

    {:ok, result}
  end
end
