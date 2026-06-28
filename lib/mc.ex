defmodule Mc do
  @modifier_function_name :m

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
    |> Enum.map(fn mod_str -> String.trim_leading(mod_str) end)
    |> Enum.reject(fn mod_str -> Ut.String.comment?(mod_str) || mod_str == "" end)
    |> Enum.map(fn mod_str -> double(mod_str) end)
  end

  defp double(mod_str) do
    case String.split(mod_str, " ", parts: 2) do
      [modifier_name, args] ->
        double(modifier_name, args)

      [modifier_name] ->
        double(modifier_name, "")
    end
  end

  defp double(modifier_name, args) do
    {String.to_atom(modifier_name), args}
  end

  defp tripleize(doubles, mappings) do
    Enum.map(doubles, fn double -> triple(double, mappings) end)
  end

  defp triple({modifier_name, args}, mappings) do
    case Map.get(mappings, modifier_name) do
      nil ->
        {Mc.Modifier.Unknown, @modifier_function_name, to_string(modifier_name)}

      module ->
        {module, @modifier_function_name, args}
    end
  end

  defp modify(triples, buffer, mappings) do
    Enum.reduce_while(triples, buffer, fn {mod, fun, args}, acc -> eval(mod, fun, args, acc, mappings) end)
  end

  defp eval(module, func_name, args, acc, mappings) do
    result = apply(module, func_name, [acc, args, mappings])

    case module do
      Mc.Modifier.Stop ->
        {:halt, result}

      _any_other_module ->
        {:cont, result}
    end
  end

  defp tupleize(result) do
    case result do
      {:error, _, _, _, _} -> result
      {:ok, _} -> result
      string -> {:ok, string}
    end
  end
end
