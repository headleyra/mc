defmodule Mc.Modifier.Invert do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Inverts the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok,
          buffer
          |> String.split("\n")
          |> Enum.reverse()
          |> Enum.join("\n")
        }

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end

  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end
end
