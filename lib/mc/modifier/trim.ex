defmodule Mc.Modifier.Trim do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Trims leading and trailing white space on the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, String.trim(buffer)}

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
