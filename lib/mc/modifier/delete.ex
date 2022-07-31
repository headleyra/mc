defmodule Mc.Modifier.Delete do
  use Mc.Railway, [:modify]

  @help """
  modifier <regex>
  modifier -h

  Deletes matching <regex> from the buffer.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        delete(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp delete(buffer, args) do
    case Regex.compile(args, "sm") do
      {:ok, regex} ->
        result = String.replace(buffer, regex, "")
        {:ok, result}

      {:error, _} ->
        usage(:modify, "<regex>")
    end
  end
end
