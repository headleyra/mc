defmodule Mc.Modifier.Version do
  use Mc.Railway, [:modify]

  def modify(_buffer, _args) do
    {:ok, Mc.MixProject.project()[:version]}
  end
end
