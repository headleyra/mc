defmodule Mc.Modifier.Range do
  use Mc.Railway, [:modify]

  @help """
  modifier [<start integer>] <end integer>
  modifier -h

  Generates a range from <start integer> to <end integer> (<start integer> defaults to 1).

  -h, --help
    Show help
  """

  def modify(_buffer, args) do
    case parse(args) do
      {_, []} ->
        range(args)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp range(args) do
    case String.split(args) |> Enum.map(&Mc.Math.str2int(&1)) do
      [{:ok, start}, {:ok, finish}] ->
        {:ok, rangeize(start, finish)}

      [{:ok, finish}] ->
        {:ok, rangeize(1, finish)}

      _bad_args ->
        oops(:modify, "bad range")
    end
  end

  defp rangeize(start, finish) do
    start..finish
    |> Enum.to_list()
    |> Enum.join("\n")
  end
end
