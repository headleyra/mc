defmodule Mc.Modifier.Grep do
  use Mc.Railway, [:modify, :modifyv]

  def modify(buffer, args) do
    grep(buffer, args, :n)
  end

  def modifyv(buffer, args) do
    grep(buffer, args, :i)
  end

  def grep(buffer, args, type) do
    case Regex.compile(args) do
      {:ok, regex} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.filter(fn line ->
            if type == :n, do: Regex.match?(regex, line), else: !Regex.match?(regex, line)
          end)
          |> Enum.join("\n")

        {:ok, result}

      {:error, _} ->
        {:error, "Grep: bad regex"}
    end
  end
end
