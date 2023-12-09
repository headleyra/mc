defmodule Mc.Modifier.Ccount do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    {:ok, 
      String.length(buffer)
      |> to_string()
    }
  end
end
