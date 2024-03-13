defmodule Mc.Modifier.Buffer do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Regex.run(~r/`(.*?)`/s, args) do
      [_, script] ->
        decoded_script = Mc.String.Inline.decode(script)
        expand(buffer, decoded_script, args, mappings)

      nil ->
        {:ok, Mc.String.Inline.decode(args)}
    end
  end

  defp expand(buffer, decoded_script, args, mappings) do
    case Mc.modify(buffer, decoded_script, mappings) do
      {:ok, replacement} ->
        args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
        modify(buffer, args_after_replacement, mappings)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
