ExUnit.start()

defmodule Check do
  def blank?({:ok, value}), do: String.trim(value) == ""
  def present?(tuple), do: !blank?(tuple)

  def has_help?(module, func) do
    help_long = apply(module, func, ["", "--help"]) |> present?()
    help_short = apply(module, func, ["", "-h"]) |> present?()
    help_long && help_short
  end
end
