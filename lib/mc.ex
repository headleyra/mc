defmodule Mc do
  def modify(buffer, script, mappings) do
    listize(script)
    |> Enum.map(fn double -> tripleize(double, mappings) end)
    |> Enum.reduce_while(
      buffer,
      fn {module, func_name, args}, acc ->
        wrap(module, func_name, args, acc, mappings)
      end)
    |> tupleize()
  end

  def listize(script) do
    script
    |> String.split("\n")
    |> Enum.map(&String.trim_leading/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reject(&Mc.String.is_comment?/1)
    |> Enum.map(&doubleize/1)
  end

  def doubleize(modify_instruction) do
    case String.split(modify_instruction, " ", parts: 2) do
      [name, args] ->
        {String.to_atom(name), args}

      [name] ->
        {String.to_atom(name), ""}
    end
  end

  def tripleize({modifier_name, args}, mappings) do
    case Map.get(mappings, modifier_name) do
      nil ->
        {Mc.Modifier.Error, :modify, "modifier not found: #{modifier_name}"}

      module ->
        {module, :modify, args}
    end
  end

  defp wrap(module, func_name, args, acc, mappings) do
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
