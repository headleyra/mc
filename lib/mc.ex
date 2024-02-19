defmodule Mc do
  def modify(buffer, script, mappings) do
    script
    |> doubleize()
    |> tripleize(mappings)
    |> transform(buffer, mappings)
    |> tupleize()
  end

  defp doubleize(script) do
    script
    |> String.split("\n")
    |> Enum.map(fn line -> String.trim_leading(line) end)
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.reject(fn line -> Mc.String.comment?(line) end)
    |> Enum.map(fn line -> double_line(line) end)
  end

  defp double_line(modify_instruction) do
    case String.split(modify_instruction, " ", parts: 2) do
      [name, args] ->
        {String.to_atom(name), args}

      [name] ->
        {String.to_atom(name), ""}
    end
  end

  defp tripleize(doubles, mappings) do
    doubles
    |> Enum.map(fn double -> triple_double(double, mappings) end)
  end

  defp triple_double({modifier_name, args}, mappings) do
    case Map.get(mappings, modifier_name) do
      nil ->
        {Mc.Modifier.Error, :modify, "modifier not found: #{modifier_name}"}

      module ->
        {module, :modify, args}
    end
  end

  defp transform(triples, buffer, mappings) do
    triples
    |> Enum.reduce_while(
      buffer,
      fn {module, func_name, args}, acc -> result_wrapper(module, func_name, args, acc, mappings) end
    )
  end

  defp result_wrapper(module, func_name, args, acc, mappings) do
    if module == Mc.Modifier.Stop do
      {:halt, apply(module, func_name, [acc, args, mappings])}
    else
      {:cont, apply(module, func_name, [acc, args, mappings])}
    end
  end

  defp tupleize(result) do
    case result do
      {:error, _} -> result
      {:ok, _} -> result
      string -> {:ok, string}
    end
  end
end
