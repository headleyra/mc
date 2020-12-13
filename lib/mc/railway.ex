# TODO: rewrite when we understand macros better :)
defmodule Mc.Railway do
  defmacro __using__(func_list) do
    oops_def =
      quote do
        defp oops(func, message) do
          {:error, "#{Mc.lookup(__MODULE__, func)}: #{message}"}
        end

        defp usage(func, args_spec) do
          {:error, "usage: #{Mc.lookup(__MODULE__, func)} #{args_spec}"}
        end
      end

    Enum.map(func_list, fn func_name ->
      quote do
        def unquote(func_name)({:error, reason}, _args) do
          {:error, reason}
        end

        def unquote(func_name)({:ok, buffer}, args) do
          unquote(func_name)(buffer, args)
        end
      end
    end)
    |> List.insert_at(-1, oops_def)
  end
end
