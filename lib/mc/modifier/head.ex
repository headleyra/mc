defmodule Mc.Modifier.Head do
  use Mc.Railway, [:modify]

  @help """
  modifier <integer>
  modifier -h

  Returns the first <integer> number of lines from the buffer.

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
        first(buffer, count)

      _error ->
        oops(:modify, "negative or non-integer line count")
    end
  end

  defp first(buffer, count) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.take(count)
      |> Enum.join("\n")
    }
  end
end
