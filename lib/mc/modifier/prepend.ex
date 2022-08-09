defmodule Mc.Modifier.Prepend do
  use Mc.Railway, [:modify]

  @help """
  modifier <inline string>
  modifier -k <key>
  modifier -h

  Prepends an <inline string> or the value of a <key>, to the buffer.

  -k <key>, --key <key>
    Prepends the value of <key>

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, decoded_string} = Mc.String.Inline.decode(args)
        {:ok, decoded_string <> buffer}

      {_, [key: key]} ->
        {:ok, data} = Mc.modify("", "get #{key}")
        {:ok, data <> buffer}

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:key, :string, :k}, {:help, :boolean, :h}])
  end
end
