defmodule Mc.Modifier.Join do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    seperator = URI.decode(args)

    {:ok,
      String.split(buffer, "\n")
      |> Enum.join(seperator)
    }
  end
end
