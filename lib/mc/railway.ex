# TODO: rewrite when we understand macros better :)
defmodule Mc.Railway do
  defmacro __using__(func_list) do
    utility_funcs =
      quote do
        def name(func_name) do
          "#{Module.split(__MODULE__) |> Enum.join(".")}##{func_name}"
        end

        def help(func_name, help_text) do
          {:ok, "#{name(func_name)}\n\n#{help_text}"}
        end

        def oops(func_name, message) do
          {:error, "#{name(func_name)}: #{message}"}
        end

        def usage(func_name, args_spec) do
          {:error, "usage: #{name(func_name)} #{args_spec}"}
        end
      end

    delegate_funcs =
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

    List.insert_at(delegate_funcs, 0, utility_funcs)
  end
end
