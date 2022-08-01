ExUnit.start()

defmodule Check do
  def blank?(nil), do: true
  def blank?(value) when is_binary(value), do: String.trim(value) == ""
  def blank?({:ok, value}), do: blank?(value)
  def present?(value), do: !blank?(value)

  def has_help?(module, func) do
    long = apply(module, func, ["", "--help"]) |> present?()
    short = apply(module, func, ["", "-h"]) |> present?()
    long && short
  end
end
