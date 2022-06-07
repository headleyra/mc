defmodule Mc.Util do
  def parse(args, triples) do
    with \
      {:ok, parse_options} <- parseify(triples),
      {options, command, []} <- OptionParser.split(args) |> OptionParser.parse(parse_options)
    do
      {Enum.join(command, " "), options}
    else
      _error ->
        :error
    end
  end

  def parseify([]), do: :error

  def parseify(triples) when is_list(triples) do
    if Enum.all?(triples, &is_triple?(&1)) do
      {:ok, optionize(triples)}
    else
      :error
    end
  end

  def parseify(_), do: :error

  defp optionize(triples) do
    Enum.reduce(
      triples,
      [{:strict, []}, {:aliases, []}],
      fn {name, type, alias}, [strict: strict_options, aliases: alias_options] ->
        [{:strict, [{name, type} | strict_options]}, {:aliases, [{alias, name} | alias_options]}]
      end
    )
  end

  def is_triple?({name, type, alias}) when is_atom(name) and is_atom(type) and is_atom(alias) do
    type_valid = type in [:boolean, :integer, :float, :string]
    alias_valid = String.length(Atom.to_string(alias)) == 1
    type_valid && alias_valid
  end

  def is_triple?(_triple), do: false
end
