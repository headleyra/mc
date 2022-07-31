defmodule Mc.Modifier.Split do
  use Mc.Railway, [:modify]

  @help """
  modifier <seperator regex>
  modifier -h

  Splits the buffer on <seperator regex>.

  -h, --help
    Show help
  """

  def modify(buffer, ""), do: {:ok, String.split(buffer) |> Enum.join("\n")}

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        splitize(buffer, args)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp splitize(buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        {:ok, String.split(buffer, regex) |> Enum.join("\n")}

      {:error, _} ->
        oops(:modify, "bad regex")
    end
  end
end
