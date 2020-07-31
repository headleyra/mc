defmodule Mc do
  use Agent

  def start_link(mappings) do
    Agent.start_link(fn -> mappings end, name: __MODULE__)
  end

  def modify(buffer, script) do
    mappings = Agent.get(__MODULE__, &(&1))

    case script_to_double_list(script) do
      [] ->
        {:ok, buffer}

      double_list ->
        double_list
        |> Enum.map(fn(double) -> double_to_triple(double, mappings) end)
        |> Enum.reduce(buffer, fn({module, modifier, args}, acc) -> apply(module, modifier, [acc, args]) end)
    end
  end

  def double_to_triple({modifier, args}, mappings) do
    case Map.get(mappings, modifier) do
      nil ->
        {Mc.Modifier.Error, :modify, "Not found: #{Atom.to_string(modifier)}"}

      {module, function} ->
        {module, function, args}
    end
  end

  def script_to_double_list(script) do
    script
    |> String.split("\n")
    |> Enum.map(& String.trim_leading(&1))
    |> Enum.reject(& &1 == "")
    |> Enum.reject(& is_comment?(&1))
    |> Enum.map(& modify_instruction_to_double(&1))
  end

  def modify_instruction_to_double(modify_instruction) do
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
