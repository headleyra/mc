defmodule Mc.Switch do
  def parse(args, switch_specs) do
    require Integer

    with \
      true <- Integer.is_even(Mc.String.count_char(args, "'")),
      true <- Integer.is_even(Mc.String.count_char(args, "\"")),

      {:ok, switch_options} <- optionize(switch_specs),
      {switches, command, []} <- OptionParser.split(args) |> OptionParser.parse(switch_options)
    do
      {Enum.join(command, " "), switches}
    else
      _error ->
        :error
    end
  end

  def optionize([]), do: :error

  def optionize(switch_specs) when is_list(switch_specs) do
    if Enum.all?(switch_specs, &is_spec?(&1)), do: {:ok, expand(switch_specs)}, else: :error
  end

  def optionize(_), do: :error

  def is_spec?({name, type, alias}) when is_atom(name) and is_atom(type) and is_atom(alias) do
    type_valid = type in [:boolean, :integer, :float, :string]
    alias_valid = String.length(Atom.to_string(alias)) == 1
    type_valid && alias_valid
  end

  def is_spec?(_triple), do: false

  defp expand(switch_specs) do
    Enum.reduce(
      switch_specs,
      [{:strict, []}, {:aliases, []}],
      fn {name, type, alias}, [strict: strict_options, aliases: alias_options] ->
        [{:strict, [{name, type} | strict_options]}, {:aliases, [{alias, name} | alias_options]}]
      end
    )
  end
end
