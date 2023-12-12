defmodule Mc.Modifier do
  defmacro __using__(_opts) do
    quote do
      def name do
        Module.split(__MODULE__)
        |> Enum.join(".")
      end

      def oops(message), do: {:error, "#{name()}: #{message}"}

      @behaviour Mc.Behaviour.Modifier
      def modify({:error, reason}, _args, _mappings), do: {:error, reason}
      def modify({:ok, buffer}, args, mappings), do: modify(buffer, args, mappings)
    end
  end
end
