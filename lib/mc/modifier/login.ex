defmodule Mc.Modifier.Login do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    if String.match?(args, ~r/^[a-z][a-z0-9]{1,15}$/) do
      Mc.modify(args, "set !user")
      {:ok, buffer}
    else
      {:error, "Login: bad userid"}
    end
  end
end
