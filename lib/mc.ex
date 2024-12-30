defmodule Mc do
  def modify(buffer, script, mappings) do
    script
    |> doubleize()
    |> tripleize(mappings)
    |> transform(buffer, mappings)
    |> tupleize()
  end

  def m(buffer, script, mappings) do
    modify(buffer, script, mappings)
  end

  def m(script, mappings) do
    modify("", script, mappings)
  end

  defp doubleize(script) do
    script
    |> String.split("\n")
    |> Enum.map(fn line -> String.trim_leading(line) end)
    |> Enum.reject(fn line -> Mc.String.comment?(line) || line == "" end)
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
    |> Enum.reduce_while(buffer, fn {mod, fun, args}, acc -> result(mod, fun, args, acc, mappings) end)
  end

  defp result(module, func_name, args, acc, mappings) do
    result = apply(module, func_name, [acc, args, mappings])
    if module == Mc.Modifier.Stop, do: {:halt, result}, else: {:cont, result}
  end

  defp tupleize(result) do
    case result do
      {:error, _} -> result
      {:ok, _} -> result
      string -> {:ok, string}
    end
  end
end
