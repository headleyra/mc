defmodule Mc.Modifier.Mcast do
  use Mc.Railway, [:modify, :modifyk]
  @timeout 40_000

  def modify(buffer, args) do
    keys = String.split(args)
    runp(buffer, keys)
  end

  def modifyk(buffer, args) do
    {:ok, key_of_keys} = Mc.modify("", "get #{args}")
    keys = String.split(key_of_keys)
    runp(buffer, keys)
  end

  defp runp(buffer, keys) do
    result =
      keys
      |> Enum.map(fn key ->
        {:ok, script} = Mc.modify("", "get #{key}")
        {String.to_atom(key), Task.async(fn -> Mc.modify(buffer, script) end)}
      end)
      |> Enum.map(fn {key, task} -> {key, Task.await(task, @timeout)} end)
      |> Enum.map(fn {key, {status, task_result}} -> "#{key}: #{status}: #{task_result}" end)
      |> Enum.join("\n")

    {:ok, result}
  end
end
