defmodule Mc.Modifier.Join do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, seperator} =  Mc.String.Inline.uri_decode(args)

    {:ok,
      String.split(buffer, "\n")
      |> Enum.join(seperator)
    }
  end
end
