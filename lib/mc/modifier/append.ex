defmodule Mc.Modifier.Append do
  use Mc.Railway, [:modify]

  @help """
  modifier <inline script>
  modifier -k <key>
  modifier -h

  Appends an inline string or the value of a key, to the buffer.

  -k <key>, --key <key>
    The key holding the value to append

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, decoded_string} = Mc.String.Inline.decode(args)
        {:ok, buffer <> decoded_string}

      {_, [key: key]} ->
        {:ok, data} = Mc.modify("", "get #{key}")
        {:ok, buffer <> data}

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:key, :string, :k}, {:help, :boolean, :h}])
  end
end
