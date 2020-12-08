defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]

  # TODO: refactor
  def modify(buffer, args) do
    case Regex.run(~r/`(.*?)`/s, args) do
      [_, script] ->
        case Mc.Util.Sys.decode(script) do
          {:error, ""} ->
            oops("bad URI", :modify)

          decoded_script ->
            case Mc.modify(buffer, decoded_script) do
              {:ok, replacement} ->
                args_after_replacement = String.replace(args, ~r/`.*?`/s, replacement, global: false)
                modify(buffer, args_after_replacement)

              {:error, reason} ->
                {:error, reason}
            end
        end

      nil ->
        case Mc.Util.Sys.decode(args) do
          {:error, ""} ->
            oops("bad URI", :modify)

          decoded_script ->
            {:ok, decoded_script}
        end
    end
  end
end
