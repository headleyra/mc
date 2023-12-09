defmodule Mc.App do
  @arg_prefix "::"
  @arg_all_specifier ":"

  def script(key_with_optional_replacements, mappings) do
    case String.split(key_with_optional_replacements, " ", parts: 2, trim: true) do
      [key] ->
        script_(key, mappings)

      [key, replacements] ->
        {:ok, script} = script_(key, mappings)
        expand(script, String.split(replacements))

      [] ->
        script_("", mappings)
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

  defp script_(key, mappings) do
    sub_keys =
      case Mc.modify("", "get #{key}", mappings) do
        {:ok, keys} ->
          keys

        {:error, "not found"} ->
          ""
      end

    {:ok,
      String.split(sub_keys)
      |> Enum.map(&Mc.modify("", "get #{&1}", mappings))
      |> Enum.map(fn {:ok, script} -> script end)
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n")
    }
  end
end
