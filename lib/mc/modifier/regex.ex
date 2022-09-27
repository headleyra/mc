defmodule Mc.Modifier.Regex do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Regex.compile(args, "s") do
      {:ok, regx} ->
        case Regex.run(regx, buffer, capture: :all) do
          [complete_match] ->
            {:ok, complete_match}

          [_complete_match | explicit_captures] ->
            {:ok, Enum.join(explicit_captures, "\n")}

          nil ->
            {:ok, ""}
        end

      {:error, _} ->
        oops(:modify, "bad regex")
    end
  end
end
