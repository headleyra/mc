defmodule Mc.Modifier.Buffer do
  use Mc.Railway, [:modify]
  @err_msg "Buffer: bad URI"

  # TODO: Refactor
  def modify(buffer, args) do
    case Regex.run(~r/`(.*?)`/s, args) do
      [_, script] ->
        case Mc.Util.Sys.decode(script) do
          {:error, ""} ->
            {:error, @err_msg}

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
            {:error, @err_msg}

          decoded_script ->
            {:ok, decoded_script}
        end
    end
  end
end
