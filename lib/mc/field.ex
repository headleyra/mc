defmodule Mc.Field do
  def parse(string, spec, separator, joiner) do
    split_list = String.split(string, URI.decode(separator))

    case Mc.Select.parse(spec) do
      :error ->
        {:error, :bad_spec}

      spec_list ->
        spec_list
        |> List.flatten()
        |> Enum.reduce([], fn index, acc -> get(split_list, index, acc) end)
        |> finish(URI.decode(joiner))
    end
  end

  defp get(split_list, index, acc) do
    [Enum.at(split_list, index) | acc]
  end

  defp finish(split_list, joiner) do
    result =
      split_list
      |> Enum.reverse()
      |> Enum.join(joiner)

    {:ok, result}
  end
end
