defmodule Mc.Modifier.Split do
  use Mc.Modifier

  def modify(buffer, "", _mappings) do
    String.split(buffer)
    |> split()
  end

  def modify(buffer, args, _mappings) do
    {:ok, split_str} = Mc.Uri.decode(args)

    String.split(buffer, split_str)
    |> split()
  end

  defp split(buffer_list) do
    {:ok,
      buffer_list
      |> Enum.join("\n")
    }
  end
end
