defmodule Mc.Modifier.Tail do
  use Mc.Railway, [:modify]

  @help """
  modifier <integer>
  modifier -h

  Returns the last <integer> number of lines from the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        lines(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp lines(buffer, args) do
    case Mc.Math.str2int(args) do
      {:ok, count} when count >= 0 ->
        last(buffer, count)

      _bad_args ->
        oops(:modify, "negative or non-integer line count")
    end
  end

  defp last(buffer, count) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.take(count)
      |> Enum.reverse()
      |> Enum.join("\n")
    }
  end
end
