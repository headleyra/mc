defmodule Mc.Modifier.Ccount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    {:ok, 
      String.length(buffer)
      |> Integer.to_string()
    }
  end
end
