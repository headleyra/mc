defmodule Mc.Modifier.Grep do
  use Mc.Railway, [:modify, :modifyv]

  def modify(buffer, args) do
    grep(buffer, args, :modify, &Regex.match?/2)
  end

  def modifyv(buffer, args) do
    grep(buffer, args, :modifyv, &(Regex.match?(&1, &2) == false))
  end

  defp grep(buffer, args, func_atom, match_func) do
    case Regex.compile(args) do
      {:ok, regex} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.filter(fn line -> match_func.(regex, line) end)
          |> Enum.join("\n")

        {:ok, result}

      {:error, _} ->
        usage(func_atom, "<regex>")
    end
  end
end
