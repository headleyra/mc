defmodule Mc.Modifier.Add do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Sums numbers in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        sum(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp sum(buffer) do
    case Mc.String.numberize(buffer) do
      [] ->
        oops(:modify, "no numbers found")

      numbers ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc + number end)
          |> to_string()
        }
    end
  end
end
