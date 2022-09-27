defmodule Mc.Modifier.Lcount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.count()
      |> Integer.to_string()
    }
  end
end
