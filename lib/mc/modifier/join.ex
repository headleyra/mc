defmodule Mc.Modifier.Join do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  TBA.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {args_pure, []} ->
        glue(buffer, args_pure)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp glue(buffer, args) do
    case Mc.String.Inline.uri_decode(args) do
      {:ok, seperator} ->
        {:ok,
          String.split(buffer, "\n")
          |> Enum.join(seperator)
        }

      _error ->
        usage(:modify, "<URI-encoded separator>")
    end
  end
end
