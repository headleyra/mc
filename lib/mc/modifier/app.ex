defmodule Mc.Modifier.App do
  use Mc.Railway, [:modify, :modifyr]
  @search_prefix "::"

  def modify(_buffer, args) do
    case String.split(args, ~r/\s+/, parts: 2) do
      [app_name] ->
        {:ok, build(app_name)}

      [app_name, replacements] ->
        {result, _search_count} =
          Enum.reduce(String.split(replacements), {build(app_name), 1}, fn(replacement, {script, search_count}) ->
            {:ok, script_after_replacement} = Mc.modify(script, "replace #{@search_prefix}#{search_count} #{replacement}")
            {script_after_replacement, search_count+1}
          end)

        {:ok, result}
    end
  end

  def modifyr(buffer, args) do
    {:ok, script} = modify("", args)
    Mc.modify(buffer, script)
  end

  def build(app_name) do
    {:ok, sub_app_names} = Mc.modify("", "get #{app_name}")
    String.split(sub_app_names)
    |> Enum.map(& Mc.modify("", "get #{&1}"))
    |> Enum.map(fn({:ok, script}) -> script end)
    |> Enum.reject(fn(e) -> e == "" end)
    |> Enum.join("\n")
  end
end
