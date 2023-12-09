defmodule Mc.Modifier.Mapc do
  use Mc.Railway, [:modify] 

  def modify(buffer, args, mappings) do
    with \
      {{:ok, concurrency}, script} when concurrency > 0 <- concurrency_with_args(args)
    do
      run_concurrent(buffer, script, concurrency, mappings)
    else
      _bad_concurrency ->
        oops(:modify, "'concurrency' should be a positive integer")
    end
  end

  defp concurrency_with_args(args) do
    case String.trim(args) |> String.split(~r/\s+/, parts: 2) do
      [concurrency, script] ->
        {Mc.String.to_int(concurrency), script}

      [concurrency] ->
        {Mc.String.to_int(concurrency), ""}

      _error ->
        :error
    end
  end
  
  defp run_concurrent(buffer, script, concurrency, mappings) do
    String.split(buffer, "\n")
    |> Task.async_stream(&Mc.modify(&1, script, mappings), ordered: true, max_concurrency: concurrency, timeout: :infinity)
    |> report()
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
