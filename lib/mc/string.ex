defmodule Mc.String do
  def numberize(string) do
    {:ok,
      string
      |> String.split()
      |> Enum.map(fn number -> to_num(number) end)
      |> Enum.reject(fn number_tuple -> number_tuple == :error end)
      |> Enum.map(fn {:ok, number} -> number end)
    }
  end

  def comment?(string) do
    String.match?(string, ~r/^\s*#/)
  end

  def grep(string, regex_str, options) do
    match_func = if options[:match], do: &Regex.match?/2, else: &(!Regex.match?(&1, &2))
    grep_(string, regex_str, match_func)
  end

  defp grep_(string, regex_str, match_func) do
    case Regex.compile(regex_str) do
      {:ok, regex} ->
        {:ok,
          string
          |> String.split("\n")
          |> Enum.filter(fn line -> match_func.(regex, line) end)
          |> Enum.join("\n")
        }

      {:error, _} ->
        {:error, "bad regex"}
    end
  end

  def sort(string, options) do
    sort_func = if options[:ascending], do: &(&1 <= &2), else: &(&2 <= &1) 
    
    {:ok,
      string
      |> String.split("\n")
      |> Enum.sort(sort_func)
      |> Enum.join("\n")
    }
  end

  def to_num(string) do
    case to_int(string) do
      :error ->
        to_flt(string)

      ok_tuple ->
        ok_tuple
    end
  end

  def to_int(string) do
    try do
      {:ok, String.to_integer(string)}
    rescue
      ArgumentError ->
        :error
    end
  end

  def to_flt(string) do
    try do
      {:ok, String.to_float(string)}
    rescue
      ArgumentError ->
        :error
    end
  end
end
