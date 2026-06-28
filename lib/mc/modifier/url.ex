defmodule Mc.Modifier.Url do
  use Mc.Modifier

  def m(_buffer, args, _mappings) do
    case adapter().get(args) do
      {:ok, result} ->
        {:ok, result}

      {:error, _reason} ->
        oops(:adapter_error, nil)
    end
  end

  defp adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
