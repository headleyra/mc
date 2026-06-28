defmodule Mc.Modifier.CountL do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    case buffer do
      "" ->
        {:ok, "0"}

      non_empty_buffer ->
        {:ok,
          non_empty_buffer
          |> String.split("\n")
          |> Enum.count()
          |> to_string()
        }
    end
  end
end
