defmodule Mc.Modifier.If do
  use Mc.Railway, [:modify]

  @help """
  modifier <compare key> <true key> <false key>
  modifier -h

  Runs the value of <true key> (against the buffer) if the buffer is the same as the value of <compare key>,
  else runs the value of <false key>.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        ife(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp ife(buffer, args) do
    with \
      [compare_key, true_key, false_key] <- String.split(args),
      {:ok, compare_value} = Mc.modify("", "get #{compare_key}")
    do
      if buffer == compare_value do
        Mc.modify(buffer, "run -k #{true_key}")
      else
        Mc.modify(buffer, "run -k #{false_key}")
      end
    else
      _bad_args ->
        usage(:modify, "<compare key> <true key> <false key>")
    end
  end
end
