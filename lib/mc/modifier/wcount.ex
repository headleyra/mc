defmodule Mc.Modifier.Wcount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    result =
      String.split(buffer, ~r/\s+/)
      |> Enum.reject(& &1 == "")
      |> Enum.count()
      |> Integer.to_string()

    {:ok, result}
  end
end
