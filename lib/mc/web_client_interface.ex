defmodule Mc.WebClientInterface do
  defmacro __using__(_) do
    quote do
      def get(url), do: {url}
      def post(url, params_map), do: {url, params_map}

      defoverridable get: 1
      defoverridable post: 2
    end
  end
end
