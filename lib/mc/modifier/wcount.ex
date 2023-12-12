defmodule Mc.Modifier.Wcount do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok,
      String.split(buffer, ~r/\s+/)
      |> Enum.reject(& &1 == "")
      |> Enum.count()
      |> Integer.to_string()
    }
  end
end
