defmodule Mc.Modifier.CountC do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, 
      String.length(buffer)
      |> to_string()
    }
  end
end
