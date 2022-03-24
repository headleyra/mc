defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]
  @argspec "<inline string>"

  def modify(buffer, args) do
    with \
      [_, script] <- Regex.run(~r/`(.*?)`/s, args),
      {:ok, decoded_script} <- Mc.Util.InlineString.decode(script)
    do
      modify_decoded_script(buffer, decoded_script, args)
    else
      nil ->
        case Mc.Util.InlineString.decode(args) do
          {:ok, decoded_script} ->
            {:ok, decoded_script}

          _error ->
            usage(:modify, @argspec)
        end

      _error ->
        usage(:modify, @argspec)
    end
  end

  defp modify_decoded_script(buffer, decoded_script, args) do
    case Mc.modify(buffer, decoded_script) do
      {:ok, replacement} ->
        args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
        modify(buffer, args_after_replacement)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
