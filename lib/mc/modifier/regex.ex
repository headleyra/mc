defmodule Mc.Modifier.Regex do
  use Mc.Railway, [:modify]

  @help """
  modifier <regex>
  modifier -h

  Runs the <regex> on the buffer and returns any matches.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        regexize(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp regexize(buffer, args) do
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
        oops(:modify, "bad regex")
    end
  end
end
