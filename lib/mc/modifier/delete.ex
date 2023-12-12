defmodule Mc.Modifier.Delete do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        {:ok, String.replace(buffer, regex, "")}

      {:error, _} ->
        oops("bad regex")
    end
  end
end
