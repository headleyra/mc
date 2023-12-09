defmodule Mc.Railway do
  defmacro __using__(func_list) do
    utility_funcs =
      quote do
        def name(func_name), do: "#{Module.split(__MODULE__) |> Enum.join(".")}##{func_name}"
        def oops(func_name, message), do: {:error, "#{name(func_name)}: #{message}"}
      end

    delegate_funcs =
      Enum.map(func_list, fn func_name ->
        quote do
          def unquote(func_name)({:error, reason}, _args, _mappings), do: {:error, reason}
          def unquote(func_name)({:ok, buffer}, args, mappings), do: unquote(func_name)(buffer, args, mappings)
        end
      end)

    List.insert_at(delegate_funcs, 0, utility_funcs)
  end
end
