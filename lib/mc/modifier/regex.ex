defmodule Mc.Modifier.Regex do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Regex.compile(args, "sm") do
      {:ok, regx} ->
        case Regex.run(regx, buffer, capture: :all) do
          [complete_match] ->
            {:ok, complete_match}

          [_complete_match | explicit_captures] ->
            {:ok, Enum.join(explicit_captures, "\n")}

          nil ->
            {:ok, ""}
        end

      {:error, _} ->
        oops("bad regex")
    end
  end
end
