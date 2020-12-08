defmodule Mc.X.Font do
  use Mc.Railway, [:modify]

  def modify(_buffer, ""), do: oops("no font specified", :modify)

  def modify(buffer, args) do
    font_name = args

    Mc.Client.Http.post("#{endpoint()}/#{font_name}.html", %{text: buffer})
    |> Mc.Modifier.Hselc.modify("pre")
  end

  def endpoint do
    System.get_env("FONT_ENDPOINT")
  end
end
