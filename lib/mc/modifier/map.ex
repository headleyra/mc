defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify]
  @timeout 100_000
  @concurrency 1

  def modify(buffer, args) do
    String.split(buffer, "\n")
    |> Task.async_stream(fn line -> Mc.modify(line, args) end,
      ordered: true,
      max_concurrency: @concurrency,
      timeout: @timeout
    )
    |> report()
  end

  defp report(results) do
    result =
      Stream.map(
        results,
        fn
          {:ok, {:ok, result}} ->
            result

          {:ok, {:error, reason}} ->
            "ERROR: #{reason}"
        end
      )
      |> Enum.join("\n")

    {:ok, result}
  end

  # def parse(args) do
  #   with \
  #     [max, script] <- String.split(args, ~r/\s+/, parts: 2),
  #     {:ok, max} when is_integer(max) and max in 1..8 <- Mc.Math.str2int(max)
  #   do
  #     {max, script}
  #   else
  #     _error ->
  #       :error
  #   end
  # end
end
