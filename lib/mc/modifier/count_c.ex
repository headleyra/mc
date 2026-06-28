defmodule Mc.Modifier.CountC do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    {:ok, 
      buffer
      |> String.length()
      |> to_string()
    }
  end
end
