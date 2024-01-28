defmodule Mc.Modifier.CountL do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    case buffer do
      "" ->
        {:ok, "0"}

      non_empty_buffer ->
        {:ok,
          String.split(non_empty_buffer, "\n")
          |> Enum.count()
          |> to_string()
        }
    end
  end
end
