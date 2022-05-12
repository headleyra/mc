defmodule Mc.Modifier.App do
  use Mc.Railway, [:modify, :modifyr]
  @arg_prefix "::"
  @arg_all ":"

  def modify(_buffer, args) do
    case String.split(args, ~r/\s+/, parts: 2) do
      [app_name] ->
        {:ok, build(app_name)}

      [app_name, replacements] ->
        script_from(build(app_name), replacements)
    end
  end

  def modifyr(buffer, args) do
    {:ok, script} = modify("", args)
    Mc.modify(buffer, script)
  end

  def build(app_name) do
    {:ok, sub_app_names} = Mc.modify("", "get #{app_name}")

    String.split(sub_app_names)
    |> Enum.map(&Mc.modify("", "get #{&1}"))
    |> Enum.map(fn {:ok, script} -> script end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
  end

  def script_from(script, replacements) do
    replace_script =
      String.split(replacements)
      |> Enum.with_index(1)
      |> Enum.into([], fn {arg, index} -> {"#{@arg_prefix}#{index}", arg} end)
      |> Enum.map(fn {search, replace} -> "replace #{search} #{replace}" end)
      |> Enum.join("\n")

    replace_arg_all = "\nreplace #{@arg_prefix}#{@arg_all} #{replacements}"
    Mc.modify(script, replace_script <> replace_arg_all)
  end
end
