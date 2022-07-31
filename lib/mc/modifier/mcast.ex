defmodule Mc.Modifier.Mcast do
  use Mc.Railway, [:modify]

  @help """
  modifier <key1> {<key2>}
  modifier -k <key>
  modifier -h

  Runs scripts, referenced by <keys>, against the buffer, returning the results for each.

  -k <key>, --key <key>
    Where <key> references a value that is a list of white-space separated keys, i.e., 2 levels of indirection

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        keyize(buffer, args)

      {_, [key: key]} ->
        keyize_i(buffer, key)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:key, :string, :k}, {:help, :boolean, :h}])
  end

  defp keyize(buffer, args) do
    keys = String.split(args)
    runp(buffer, keys)
  end

  defp keyize_i(buffer, args) do
    {:ok, key_of_keys} = Mc.modify("", "get #{args}")
    keyize(buffer, key_of_keys)
  end

  defp runp(buffer, keys) do
    result =
      keys
      |> Enum.map(fn key ->
        {:ok, script} = Mc.modify("", "get #{key}")
        {String.to_atom(key), Task.async(fn -> Mc.modify(buffer, script) end)}
      end)
      |> Enum.map(fn {key, task} -> {key, Task.await(task, :infinity)} end)
      |> Enum.map(fn {key, {status, task_result}} -> "#{key}: #{status}: #{task_result}" end)
      |> Enum.join("\n")

    {:ok, result}
  end
end
