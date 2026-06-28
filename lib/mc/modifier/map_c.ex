defmodule Mc.Modifier.MapC do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    case concurrency_with_script(args) do
      {{:ok, concurrency}, script} when concurrency > 0 ->
        run(buffer, script, concurrency, mappings)

      _error ->
        oops(:bad_concurrency, args)
    end
  end

  defp concurrency_with_script(args) do
    concurrency_script =
      args
      |> String.trim()
      |> String.split(~r/\s+/, parts: 2)

    case concurrency_script do
      [concurrency, script] ->
        {Ut.String.to_int(concurrency), script}

      [concurrency] ->
        {Ut.String.to_int(concurrency), ""}
    end
  end
  
  defp run(buffer, script, maxc, mappings) do
    {:ok,
      String.split(buffer, "\n")
      |> task_stream(script, maxc, mappings)
      |> Stream.map(fn e -> detuple(e) end)
      |> Enum.join("\n")
    }
  end

  defp task_stream(buffers, script, maxc, mappings) do
    Task.async_stream(
      buffers,
      fn buffer -> Mc.m(buffer, script, mappings) end,
      ordered: true,
      max_concurrency: maxc,
      timeout: :infinity
    )
  end

  defp detuple({:ok, {:ok, result}}), do: result
  defp detuple({:ok, {:error, Mc.Modifier.Unknown, _, message, _}}), do: "ERROR: modifier unknown: #{message}"
  defp detuple({:ok, {:error, _, _, message, _}}), do: "ERROR: #{message}"
end
