defmodule Mc do
  use Agent

  def start_link(mappings: mappings) do
    Agent.start_link(fn -> {mappings, flatten(mappings)} end, name: __MODULE__)
  end

  def modify(buffer, script) do
    {mappings, _flat_mappings} = Agent.get(__MODULE__, & &1)

    case doubleize(script) do
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
        {Mc.Modifier.Error, :modify, "not found: #{modifier_name}"}
    end
  end

  def doubleize(script) do
    script
    |> String.split("\n")
    |> Enum.map(&String.trim_leading(&1))
    |> Enum.reject(&(&1 == ""))
    |> Enum.reject(&is_comment?(&1))
    |> Enum.map(&to_double(&1))
  end

  def to_double(modify_instruction) do
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

  def lookup(lookup_module, lookup_func) do
    {_mappings, flat_mappings} = Agent.get(__MODULE__, & &1)

    flat_mappings
    |> Enum.filter(fn {{module, func}, _name} ->
      module == lookup_module && func == lookup_func
    end)
    |> Enum.at(0)
    |> (fn
          {{_module, _func}, name} -> name
          nil -> nil
        end).()
  end

  def flatten(mappings) when is_struct(mappings) do
    map = mappings |> Map.from_struct()
    flatten(map)
  end

  def flatten(mappings) do
    mappings
    |> Map.keys()
    |> Enum.map(fn key -> {Map.get(mappings, key), "#{key}"} end)
    |> Enum.sort(fn {{_, _}, func1}, {{_, _}, func2} ->
      byte_size("#{func1}") >= byte_size("#{func2}")
    end)
  end
end
