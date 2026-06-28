defmodule Mc.Modifier.Regex do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        match(regex, buffer)

      {:error, _} ->
        oops(:bad_regex, args)
    end
  end

  defp match(regex, buffer) do
    case Regex.run(regex, buffer, capture: :all) do
      [complete_match] ->
        {:ok, complete_match}

      [_complete_match | explicit_captures] ->
        captures = Enum.join(explicit_captures, "\n")
        {:ok, captures}

      nil ->
        {:ok, ""}
    end
  end
end
