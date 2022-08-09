defmodule Mc.Modifier.Iword do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Parses the buffer as an integer and returns its 'word' equivalent.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        wordify(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp wordify(buffer) do
    case String.trim(buffer) |> Mc.Math.str2int() do
      {:ok, int} when int < 0 ->
        {:ok, "(minus) #{Mc.NumberToWord.say(abs(int))}"}

      {:ok, int} ->
        {:ok, Mc.NumberToWord.say(int)}

      :error ->
        {:error, "Mc.Modifier.Iword#modify: no integer found"}
    end
  end
end
