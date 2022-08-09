defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify]

  @help """
  modifier [-c <max concurrency>] <script>
  modifier -h

  Runs <script> against each line in the buffer and reports the results.

  -c, --concurrency
    The maximum number of CPU cores the system should use (hint)

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {script, [concurrency: int]} ->
        String.split(buffer, "\n")
        |> Task.async_stream(&Mc.modify(&1, script), ordered: true, max_concurrency: int, timeout: :infinity)
        |> report()

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    case Mc.Switch.parse(args, [{:concurrency, :integer, :c}, {:help, :boolean, :h}]) do
      {script, []} ->
        {script, [concurrency: 1]}

      {_script, [concurrency: int]} when int <= 0 ->
        :error

      catchall ->
        catchall
    end
  end

  defp report(results) do
    {:ok,
      Stream.map(results, &detuple/1)
      |> Enum.join("\n")
    }
  end

  defp detuple({:ok, {:ok, result}}), do: result
  defp detuple({:ok, {:error, reason}}), do: "ERROR: #{reason}"
end
