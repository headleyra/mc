defmodule Mc.Modifier.Divide do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Divides numbers in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        divide(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp divide(buffer) do
    try do
      case Mc.String.numberize(buffer) do
        [] ->
          oops(:modify, "no numbers found")

        numbers ->
          {:ok,
            numbers
            |> Enum.reduce(fn number, acc -> acc / number end)
            |> to_string()
          }
      end
    rescue
      ArithmeticError ->
        oops(:modify, "divide-by-zero attempt")
    end
  end
end
