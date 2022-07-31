defmodule Mc.Modifier.Multiply do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Multiplies numbers in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        multiply(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp multiply(buffer) do
    case Mc.String.numberize(buffer) do
      [] ->
        oops(:modify, "no numbers found")

      numbers ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc * number end)
          |> to_string()
        }
    end
  end
end
