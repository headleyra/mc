defmodule Mc.Modifier.Mapc do
  use Mc.Railway, [:modify] 

  def modify(buffer, args) do
    with \
      {{:ok, max_concurrency}, rest_of_args} when max_concurrency > 0 <- max_concurrency_with_args(args)
    do
      run_concurrent(buffer, rest_of_args, max_concurrency)
    else
      _error ->
        oops(:modify, "'max concurrency' should be a positive integer")
    end
  end

  defp max_concurrency_with_args(args) do
    case String.trim(args) |> String.split(~r/\s+/, parts: 2) do
      [max_concurrency, rest_of_args] ->
        {Mc.String.str2int(max_concurrency), rest_of_args}

      [max_concurrency] ->
        {Mc.String.str2int(max_concurrency), ""}

      _error ->
        :error
    end
  end
  
  defp run_concurrent(buffer, args, max_concurrency) do
    String.split(buffer, "\n")
    |> Task.async_stream(&Mc.modify(&1, args), ordered: true, max_concurrency: max_concurrency, timeout: :infinity)
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
