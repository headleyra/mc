defmodule Mc.Modifier.Version do
  use Mc.Modifier

  def modify(_buffer, _args, _mappings) do
    result =
      :mc
      |> Application.spec(:vsn)
      |> to_string()

    {:ok, result}
  end
end
