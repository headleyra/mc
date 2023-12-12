defmodule Mc.Modifier.Buffer do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    with \
      [_, script] <- Regex.run(~r/`(.*?)`/s, args),
      {:ok, decoded_script} = Mc.String.Inline.decode(script)
    do
      run_decoded_script(buffer, decoded_script, args, mappings)
    else
      nil ->
        Mc.String.Inline.decode(args)
    end
  end

  defp run_decoded_script(buffer, decoded_script, args, mappings) do
    case Mc.modify(buffer, decoded_script, mappings) do
      {:ok, replacement} ->
        args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
        modify(buffer, args_after_replacement, mappings)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
