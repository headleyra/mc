defmodule Mc.Modifier do
  defmacro __using__(_opts) do
    quote do
      def name do
        Module.split(__MODULE__)
        |> Enum.join(".")
      end

      def oops(message), do: {:error, "#{name()}: #{message}"}

      @behaviour Mc.Behaviour.Modifier
      def m({:error, reason}, _args, _mappings), do: {:error, reason}
      def m({:ok, buffer}, args, mappings), do: m(buffer, args, mappings)
    end
  end
end
