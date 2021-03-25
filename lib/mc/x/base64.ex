defmodule Mc.X.Base64 do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    {:ok, Base.encode64(buffer)}
  end
end
