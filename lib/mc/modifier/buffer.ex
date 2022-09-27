defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    with \
      [_, script] <- Regex.run(~r/`(.*?)`/s, args),
      {:ok, decoded_script} = Mc.String.Inline.decode(script)
    do
      run_decoded_script(buffer, decoded_script, args)
    else
      nil ->
        Mc.String.Inline.decode(args)
    end
  end

  defp run_decoded_script(buffer, decoded_script, args) do
    case Mc.modify(buffer, decoded_script) do
      {:ok, replacement} ->
        args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
        modify(buffer, args_after_replacement)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
