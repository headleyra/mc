defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify]
  @timeout 40_000

  def modify(buffer, args) do
    case Mc.Util.InlineString.decode(args) do
      {:ok, script} ->
        result(buffer, script)

      _error ->
        usage(:modify, "<inline string>")
    end
  end

  defp result(buffer, script) do
    buffer2tasks(buffer, script)
    |> Enum.map(fn task -> Task.await(task, @timeout) end)
    |> report()
  end

  defp buffer2tasks(buffer, script) do
    String.split(buffer, "\n")
    |> Enum.map(fn buffer_line -> Task.async(fn -> Mc.modify(buffer_line, script) end) end)
  end

  defp report(results) do
    all_ok = Enum.all?(results, fn result -> match?({:ok, _}, result) end)
    if all_ok, do: reporta(results), else: reportb(results)
  end

  defp reporta(results) do
    result =
      Enum.map(results, fn {:ok, result} -> result end)
      |> Enum.join("\n")

    {:ok, result}
  end

  defp reportb(results) do
    Enum.reject(results, fn result -> match?({:ok, _}, result) end)
    |> List.first()
  end
end
