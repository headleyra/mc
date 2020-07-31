defmodule Mc.X.Random do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    case Mc.Util.Math.str2int(args) do
      :error ->
        {:error, "Random: not an integer"}

      int ->
        {:ok, "#{:rand.uniform(int)}"}
    end
  end
end
