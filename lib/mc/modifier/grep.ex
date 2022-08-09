defmodule Mc.Modifier.Grep do
  use Mc.Railway, [:modify]

  @help """
  modifier [-v] <regex>
  modifier -h

  Returns lines in the buffer that match the regex.

  -v, --inverse
    Returns lines that don't match the regex

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        grep(buffer, args, :modify, &Regex.match?/2)

      {args_pure, [inverse: true]} ->
        grep(buffer, args_pure, :modify, &!Regex.match?(&1, &2))

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:inverse, :boolean, :v}, {:help, :boolean, :h}])
  end

  defp grep(buffer, args, from_func, match_func) do
    case Regex.compile(args) do
      {:ok, regex} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.filter(fn line -> match_func.(regex, line) end)
          |> Enum.join("\n")

        {:ok, result}

      {:error, _} ->
        oops(from_func, "bad regex")
    end
  end
end
