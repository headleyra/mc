defmodule Mc.Modifier.Squeeze do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Squeezes white space into a single space for each line in the buffer and then trims the result.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        compact(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp compact(buffer) do
    {:ok,
      String.split(buffer, "\n")
      |> Enum.map(&String.replace(&1, ~r/\s\s+/, " "))
      |> Enum.map(&String.trim(&1))
      |> Enum.join("\n")
    }
  end
end
