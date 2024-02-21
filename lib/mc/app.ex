defmodule Mc.App do
  @arg_prefix "::"
  @arg_all_specifier ":"

  def script(key_with_optional_replacements, mappings) do
    case String.split(key_with_optional_replacements, " ", parts: 2, trim: true) do
      [key] ->
        kvget(key, mappings)

      [key, replacements] ->
        {:ok, script} = kvget(key, mappings)
        expand(script, String.split(replacements))

      [] ->
        kvget("", mappings)
    end
  end

  def expand(script, []), do: {:ok, script}
  def expand(script, replacements) do
    {:ok, 
      replacements
      |> Enum.with_index(1)
      |> Enum.into([], fn {arg, index} -> {"#{@arg_prefix}#{index}", arg} end)
      |> Enum.reduce(script, fn {search, replace}, acc -> String.replace(acc, search, replace) end)
      |> String.replace("#{@arg_prefix}#{@arg_all_specifier}", Enum.join(replacements, " "))
    }
  end

  defp kvget(key, mappings) do
    case Mc.modify("", "get #{key}", mappings) do
      {:ok, app_script} ->
        {:ok, app_script}

      {:error, _reason} ->
        {:error, :not_found}
    end
  end
end
