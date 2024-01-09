defmodule Mc.Modifier.CountL do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.count()
      |> Integer.to_string()
    }
  end
end
