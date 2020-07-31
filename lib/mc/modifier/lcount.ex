defmodule Mc.Modifier.Lcount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    result =
      String.split(buffer, "\n")
      |> Enum.count()
      |> Integer.to_string()

    {:ok, result}
  end
end
