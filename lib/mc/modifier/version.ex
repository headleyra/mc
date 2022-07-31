defmodule Mc.Modifier.Version do
  use Mc.Railway, [:modify]

  @help """
  modifier [-h]

  Returns the system version.

  -h, --help
    Show help
  """

  def modify(_buffer, args) do
    case parse(args) do
      {_, []} ->
        {:ok, Mc.MixProject.project()[:version]}

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end
end
