defmodule Mc.Modifier.Version do
  use Mc.Railway, [:modify]

  def modify(_buffer, _args) do
    result = Mc.MixProject.project()[:version]
    {:ok, result}
  end
end
