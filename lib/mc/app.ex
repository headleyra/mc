defmodule Mc.App do
  @arg_prefix "::"
  @arg_all_specifier ":"

  def script(key_with_optional_replacements, mappings) do
    case String.split(key_with_optional_replacements, " ", parts: 2, trim: true) do
      [key] ->
        kv_get(key, mappings, "")

      [key, replacements] ->
        kv_get(key, mappings, replacements)

      [] ->
        {:error, :missing_app_key, nil}
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

  defp kv_get(key, mappings, replacements) do
    case Mc.m("get #{key}", mappings) do
      {:ok, script} ->
        replacements_list = String.split(replacements)
        expand(script, replacements_list)

      {:error, _, :key_not_found, key, _} ->
        {:error, :not_found, key}
    end
  end
end
