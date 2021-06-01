defmodule Mc do
  use Agent

  def start_link(mappings: mappings) do
    Agent.start_link(fn -> mappings end, name: __MODULE__)
  end

  def modify(buffer, script) do
    mappings = Agent.get(__MODULE__, & &1)

    case listize(script) do
      [] ->
        {:ok, buffer}

      double_list ->
        double_list
        |> Enum.map(fn double -> tripleize(double, mappings) end)
        |> Enum.reduce(buffer, fn {module, modifier_name, args}, acc ->
          apply(module, modifier_name, [acc, args])
        end)
    end
  end

  def tripleize({modifier_name, args}, mappings) do
    case Map.get(mappings, modifier_name) do
      {module, func_atom} ->
        {module, func_atom, args}

      nil ->
        {Mc.Modifier.Error, :modify, "modifier not found '#{modifier_name}'"}
    end
  end

  def listize(script) do
    script
    |> String.split("\n")
    |> Enum.map(&String.trim_leading(&1))
    |> Enum.reject(&(&1 == ""))
    |> Enum.reject(&is_comment?(&1))
    |> Enum.map(&tupleize(&1))
  end

  def tupleize(modify_instruction) do
    case String.split(modify_instruction, " ", parts: 2) do
      [modifier_name, args] ->
        {String.to_atom(modifier_name), args}

      [modifier_name] ->
        {String.to_atom(modifier_name), ""}
    end
  end

  def is_comment?(string) do
    String.match?(string, ~r/^\s*#/)
  end
end
