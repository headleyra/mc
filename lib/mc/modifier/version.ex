defmodule Mc.Modifier.Version do
  use Mc.Modifier

  def modify(_buffer, _args, _mappings) do
    {:ok, Mc.MixProject.project()[:version]}
  end
end
