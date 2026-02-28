defmodule Mc.Modifier.Field do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case String.split(args) do
      [select_spec, separator, joiner] ->
        field(buffer, select_spec, separator, joiner)

      _parse_error ->
        oops("parse error")
    end
  end

  defp field(buffer, select_spec, separator, joiner) do
    case Mc.Field.parse(buffer, select_spec, separator, joiner) do
      {:error, :bad_spec} ->
        oops("bad select spec")

      {:ok, result} ->
        {:ok, result}
    end
  end
end
