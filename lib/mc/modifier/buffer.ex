defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]
  @argspec "<inline string>"

  # TODO: refactor
  def modify(buffer, args) do
    case Regex.run(~r/`(.*?)`/s, args) do
      [_, script] ->
        case Mc.Util.InlineString.decode(script) do
          {:ok, decoded_script} ->
            case Mc.modify(buffer, decoded_script) do
              {:ok, replacement} ->
                args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
                modify(buffer, args_after_replacement)

              {:error, reason} ->
                {:error, reason}
            end

          _error ->
            usage(:modify, @argspec)
        end

      nil ->
        case Mc.Util.InlineString.decode(args) do
          {:ok, decoded_script} ->
            {:ok, decoded_script}

          _error ->
            usage(:modify, @argspec)
        end
    end
  end
end
