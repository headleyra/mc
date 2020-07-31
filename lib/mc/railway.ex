# TODO: Rewrite this when we understand macros better :)
defmodule Mc.Railway do
  defmacro __using__(opts) do
    ast_defs_list =
      opts
      |> Enum.map(fn(func_name) -> train(func_name) end)

    {:__block__, [], ast_defs_list}
  end

  def train(func_name) do
    quote do
      def unquote(func_name)({:error, reason}, _args), do: {:error, reason}
      def unquote(func_name)({:ok, buffer}, args), do: unquote(func_name)(buffer, args)
    end
  end
end
