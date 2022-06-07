defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case parse(args) do
      {script, [concurrency: cc]} ->
        String.split(buffer, "\n")
        |> Task.async_stream(&Mc.modify(&1, script), ordered: true, max_concurrency: cc, timeout: :infinity)
        |> report()

      :error ->
        usage(:modify, "[-c <integer:positive>] <modifier> [<args>]")
    end
  end

  def parse(args) do
    case Mc.Util.parse(args, [{:concurrency, :integer, :c}]) do
      {script, []} ->
        {script, [concurrency: 1]}

      {script, [concurrency: cc]} when cc > 0 ->
        {script, [concurrency: cc]}

      _error ->
        :error
    end
  end

  defp report(results) do
    result =
      Stream.map(
        results,
        fn
          {:ok, {:ok, result}} ->
            result

          {:ok, {:error, reason}} ->
            "ERROR: #{reason}"
        end
      )
      |> Enum.join("\n")

    {:ok, result}
  end
end
