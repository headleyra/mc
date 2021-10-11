defmodule Mc.Modifier.Join do
  use Mc.Railway, [:modify]

  def modify(buffer, ""), do: {:ok, String.split(buffer, "\n") |> Enum.join()}
  def modify(buffer, args), do: {:ok, String.split(buffer, "\n") |> Enum.join(args)}
end
