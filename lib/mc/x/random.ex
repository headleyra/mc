defmodule Mc.X.Random do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    case Mc.Util.Math.str2int(args) do
      :error ->
        oops("not an integer", :modify)

      int ->
        {:ok, "#{:rand.uniform(int)}"}
    end
  end
end
