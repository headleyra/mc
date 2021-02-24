# TODO: rewrite when we understand macros better :)
defmodule Mc.Railway do
  defmacro __using__(func_list) do
    utility_funcs =
      quote do
        def name(atom) do
          "#{Module.split(__MODULE__) |> Enum.join(".")}##{atom}"
        end

        def oops(func, message) do
          {:error, "#{name(func)}: #{message}"}
        end

        def usage(func, args_spec) do
          {:error, "usage: #{name(func)} #{args_spec}"}
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
    |> List.insert_at(-1, utility_funcs)
  end
end
