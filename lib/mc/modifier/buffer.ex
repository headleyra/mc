defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]

  @help """
  modifier
  modifier <inline string>
  modifier [-h]

  Decodes the <inline string> and places it in the buffer.  When no <inline string> is specified
  an empty string is placed in the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        bufferize(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp bufferize(buffer, args) do
    with \
      [_, script] <- Regex.run(~r/`(.*?)`/s, args),
      {:ok, decoded_script} <- Mc.String.Inline.decode(script)
    do
      modify_decoded_script(buffer, decoded_script, args)
    else
      nil ->
        Mc.String.Inline.decode(args)
    end
  end

  defp modify_decoded_script(buffer, decoded_script, args) do
    case Mc.modify(buffer, decoded_script) do
      {:ok, replacement} ->
        args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
        modify(buffer, args_after_replacement)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
