defmodule Mc.Modifier.Error do
  use Mc.Railway, [:modify]

  @help """
  modifier <error message>
  modifier -h

  Generates an error with the given <error message>.

  -h, --help
    Show help
  """

  def modify(_buffer, args) do
    case parse(args) do
      {_, []} ->
        {:error, args}

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
