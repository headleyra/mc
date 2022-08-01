defmodule Mc.Modifier.Sort do
  use Mc.Railway, [:modify]

  @help """
  modifier [-v]
  modifier -h

  Sort buffer lines in ascending order.

  -v, --inverse
    Sort in descending order

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, sort(buffer, &(&1 <= &2))}

      {_, [inverse: true]} ->
        {:ok, sort(buffer, &(&1 >= &2))}

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  def parse(args) do
    Mc.Switch.parse(args, [{:inverse, :boolean, :v}, {:help, :boolean, :h}])
  end

  defp sort(text, func) do
    text
    |> String.split("\n")
    |> Enum.sort(func)
    |> Enum.join("\n")
  end
end
