defmodule Mc.X.Sleep do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Integer.parse(args) do
      {secs, _} ->
        Process.sleep(secs * 1_000)
      :error ->
        nil
    end
    {:ok, buffer}
  end
end
