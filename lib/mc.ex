defmodule Mc do
  def m(buffer, script, mappings) do
    script
    |> doubleize()
    |> tripleize(mappings)
    |> modify(buffer, mappings)
    |> tupleize()
  end

  def m(script, mappings) do
    m("", script, mappings)
  end

  defp doubleize(script) do
    script
    |> String.split("\n")
    |> Enum.map(&String.trim_leading(&1))
    |> Enum.reject(&(Mc.String.comment?(&1) || &1 == ""))
    |> Enum.map(&to_double(&1))
  end

  defp to_double(script_line) do
    case String.split(script_line, " ", parts: 2) do
      [modifier_name, args] ->
        to_double(modifier_name, args)

      [modifier_name] ->
        to_double(modifier_name, "")
    end
  end

  defp to_double(modifier_name, args) do
    {String.to_atom(modifier_name), args}
  end

  defp tripleize(doubles, mappings) do
    doubles
    |> Enum.map(fn double -> to_triple(double, mappings) end)
  end

  defp to_triple({modifier_name, args}, mappings) do
    case Map.get(mappings, modifier_name) do
      nil ->
        {Mc.Modifier.Error, :m, "modifier not found: #{modifier_name}"}

      module ->
        {module, :m, args}
    end
  end

  defp modify(triples, buffer, mappings) do
    triples
    |> Enum.reduce_while(buffer, fn {mod, fun, args}, acc -> eval(mod, fun, args, acc, mappings) end)
  end

  defp eval(module, func_name, args, acc, mappings) do
    result = apply(module, func_name, [acc, args, mappings])

    case module do
      Mc.Modifier.Stop ->
        {:halt, result}

      _module ->
        {:cont, result}
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
