defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify]
  @timeout 20_000

  def modify(buffer, args) do
    case Mc.Util.Sys.decode(args) do
      {:error, _} ->
        {:error, "Map: bad URI"}

      script ->
        result(buffer, script)
    end
  end

  defp result(buffer, script) do
    buffer2tasks(buffer, script)
    |> Enum.map(fn task -> Task.await(task, @timeout) end)
    |> report()
  end

  defp buffer2tasks(buffer, script) do
    buffer_lines = String.split(buffer, "\n")
    Enum.map(buffer_lines, fn line -> Task.async(fn -> Mc.modify(line, script) end) end)
  end

  defp report(results) do
    if Enum.all?(results, fn result -> match?({:ok, _}, result) end) do
      {:ok,
        Enum.map(results, fn {:ok, result} -> result end)
        |> Enum.join("\n")}
    else
      Enum.reject(results, fn result -> match?({:ok, _}, result) end)
      |> List.first()
    end
  end
end
