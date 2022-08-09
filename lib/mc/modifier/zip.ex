defmodule Mc.Modifier.Zip do
  use Mc.Railway, [:modify]

  @help """
  modifier <URI-encoded separator> <key>
  modifier -h

  Zips together the buffer, and the value of <key>, using a <URI-encoded separator>.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {args_pure, []} ->
        zip(buffer, args_pure)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp zip(buffer, args) do
    case String.split(args) do
      [separator, key] ->
        {:ok, zipee} = Mc.modify("", "get #{key}")
        buffer_list = String.split(buffer, "\n")
        zipee_list = String.split(zipee, "\n")
        {:ok, decoded_separator} = Mc.String.Inline.uri_decode(separator)

        {:ok,
          Enum.zip(buffer_list, zipee_list)
          |> Enum.map(fn {b, z} -> "#{b}#{decoded_separator}#{z}" end)
          |> Enum.join("\n")
        }

      _bad_args ->
        oops(:modify, "args parse error")
    end
  end
end
