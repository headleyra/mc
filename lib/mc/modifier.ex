defmodule Mc.Modifier do
  defmacro __using__(_opts) do
    quote do
      @behaviour Mc.Behaviour.Modifier

      def m({:error, modifier_module, type, message, list}, _args, _mappings) do
        {:error, modifier_module, type, message, list}
      end

      def m({:ok, buffer}, args, mappings) do
        m(buffer, args, mappings)
      end

      def oops(type, message) do
        {:error, __MODULE__, type, message, []}
      end

      def oops({:ok, result}, _message, _raised_error) do
        {:ok, result}
      end

      def oops({:error, _, _, _, _} = raised_error, type, message) do
        oops(type, message, raised_error)
      end

      def oops(type, message, raised_error) do
        error = oops(type, message)
        stack(error, raised_error)
      end

      defp stack(wrapper_error, raised_error) do
        {:error, w_mod, w_typ, w_msg, _} = wrapper_error
        {:error, r_mod, r_typ, r_msg, r_lst} = raised_error

        raised_mini_error = {r_mod, r_typ, r_msg}
        new_stacked_errors = [raised_mini_error | r_lst]

        {:error, w_mod, w_typ, w_msg, new_stacked_errors} 
      end
    end
  end
end
