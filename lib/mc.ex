defmodule Mc do
  use Agent

  def start_link(mappings: mappings) do
    Agent.start_link(fn -> mappings end, name: __MODULE__)
  end

  def mappings do
    Agent.get(__MODULE__, & &1)
  end

  def modify(buffer, script) do
    listize(script)
    |> Enum.map(fn double -> tripleize(double, mappings()) end)
    |> Enum.reduce(buffer, fn {module, name, args}, acc -> apply(module, name, [acc, args]) end)
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
      {module, name} ->
        {module, name, args}

      nil ->
        {Mc.Modifier.Error, :modify, "modifier not found: #{modifier_name}"}
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
