defmodule Mc.Modifier.App do
  use Mc.Railway, [:modify]

  @arg_prefix "::"
  @arg_all_specifier ":"

  @help """
  modifier [-s] <key> [{<replacement>}]
  modifier -h

  Builds an 'app' script (given an 'app' key and 'script placeholder replacements') and runs it
  against the buffer.

  -s, --script
    Returns the app script only

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {app_key_with_replacements, []} ->
        run(buffer, app_key_with_replacements)

      {app_key_with_replacements, [script: true]} ->
        get_script(app_key_with_replacements)

      {_, [help: true]} ->
        help(:modify, @help)

      _error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:script, :boolean, :s}, {:help, :boolean, :h}])
  end

  defp get_raw_script(app_key) do
    {:ok, sub_app_keys} = Mc.modify("", "get #{app_key}")

    String.split(sub_app_keys)
    |> Enum.map(&Mc.modify("", "get #{&1}"))
    |> Enum.map(fn {:ok, script} -> script end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
  end

  defp expand(text, replacements) do
    replacer_script =
      String.split(replacements)
      |> Enum.with_index(1)
      |> Enum.into([], fn {arg, index} -> {"#{@arg_prefix}#{index}", arg} end)
      |> Enum.map(fn {search, replace} -> "replace #{search} #{replace}" end)
      |> Enum.join("\n")

    replace_arg_all_script = "\nreplace #{@arg_prefix}#{@arg_all_specifier} #{replacements}"
    Mc.modify(text, replacer_script <> replace_arg_all_script)
  end

  defp run(buffer, app_key_with_replacements) do
    {:ok, script} = get_script(app_key_with_replacements)
    Mc.modify(buffer, script)
  end

  defp get_script(app_key_with_replacements) do
    case String.split(app_key_with_replacements, ~r/\s+/, parts: 2) do
      [app_key] ->
        {:ok, get_raw_script(app_key)}

      [app_key, replacements] ->
        expand(get_raw_script(app_key), replacements)
    end
  end
end
