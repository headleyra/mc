defmodule Mc.Modifier.Wcount do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Counts the number of words in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        count(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp count(buffer) do
    {:ok,
      String.split(buffer, ~r/\s+/)
      |> Enum.reject(& &1 == "")
      |> Enum.count()
      |> Integer.to_string()
    }
  end
end
