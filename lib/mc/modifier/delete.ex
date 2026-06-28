defmodule Mc.Modifier.Delete do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        {:ok, String.replace(buffer, regex, "")}

      {:error, _} ->
        oops(:bad_regex, args)
    end
  end
end
