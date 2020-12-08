defmodule Mc.Modifier.Error do
  def modify({:error, reason}, _args), do: {:error, reason}

  def modify(_buffer, args) do
    {:error, args}
  end
end
