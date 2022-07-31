defmodule Mc.Modifier.Ccount do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Counts the number of characters in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        count(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp count(buffer) do
    result =
      String.length(buffer)
      |> Integer.to_string()

    {:ok, result}
  end
end
