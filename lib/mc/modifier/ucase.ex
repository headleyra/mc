defmodule Mc.Modifier.Ucase do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Uppercases the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, String.upcase(buffer)}

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end
end
