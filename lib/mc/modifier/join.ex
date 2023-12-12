defmodule Mc.Modifier.Join do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    {:ok, seperator} =  Mc.Uri.decode(args)

    {:ok,
      String.split(buffer, "\n")
      |> Enum.join(seperator)
    }
  end
end
