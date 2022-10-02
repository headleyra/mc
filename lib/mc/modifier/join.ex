defmodule Mc.Modifier.Join do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, seperator} =  Mc.Uri.decode(args)

    {:ok,
      String.split(buffer, "\n")
      |> Enum.join(seperator)
    }
  end
end
