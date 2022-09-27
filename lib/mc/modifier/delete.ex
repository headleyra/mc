defmodule Mc.Modifier.Delete do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        {:ok, String.replace(buffer, regex, "")}

      {:error, _} ->
        oops(:modify, "bad regex")
    end
  end
end
