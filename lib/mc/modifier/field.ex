defmodule Mc.Modifier.Field do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case String.split(args) do
      [select_spec, separator, joiner] ->
        field(buffer, select_spec, separator, joiner, args)

      _parse_error ->
        oops(:parse_error, args)
    end
  end

  defp field(buffer, select_spec, separator, joiner, args) do
    case Ut.Field.join(buffer, select_spec, separator, joiner) do
      {:ok, result} ->
        {:ok, result}

      {:error, :bad_spec} ->
        oops(:parse_error, args)
    end
  end
end
