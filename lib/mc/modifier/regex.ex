defmodule Mc.Modifier.Regex do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Regex.compile(args, "s") do
      {:ok, regx} ->
        case Regex.run(regx, buffer, capture: :all) do
          [match_with_no_captures] ->
            {:ok, match_with_no_captures}

          [_complete_match | captured_matches] ->
            {:ok, Enum.join(captured_matches, "\n")}

          nil ->
            {:ok, ""}
        end

      {:error, _} ->
        usage(:modify, "<regex>")
    end
  end
end
