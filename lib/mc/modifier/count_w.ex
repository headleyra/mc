defmodule Mc.Modifier.CountW do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    {:ok,
      buffer
      |> String.split(~r/\s+/)
      |> Enum.reject(fn word -> word == "" end)
      |> Enum.count()
      |> to_string()
    }
  end
end
