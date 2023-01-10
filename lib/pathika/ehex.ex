defmodule Pathika.Ehex do
  @moduledoc """
  Converts values to and from Traveller5 Expanded Hexadecimal, allowing values
  from 0 to 33 to be represented by the numbers 0-9 and the letters A-Z,
  omitting I and O.
  """
  @spec to_ehex(rating :: :unknown | integer) :: String.t()
  @doc """
  Converts an integer value to it's corresponding eHex string. Placeholer values
  ":unknown" or numbers out of the 0-33 range are returned as "?".

  ## Examples
      iex> alias Pathika.Ehex
      Pathika.Ehex
      iex> Ehex.to_ehex(10)
      "A"
      iex> Ehex.to_ehex(9)
      "9"
      iex> Ehex.to_ehex(:unknown)
      "?"
      iex> Ehex.to_ehex(1000)
      "?"
  """
  def to_ehex(:unknown), do: "?"
  def to_ehex(rating) when rating in 0..9, do: Integer.to_string(rating)
  def to_ehex(rating) when is_integer(rating), do: Map.get(ehex(), rating, "?")

  @spec from_ehex(rating :: String.t()) :: :unknown | non_neg_integer
  @doc """
  Converts an eHex string to it's corresponding integer value. All inputs aside
  from valid eHex characters are returned as :unknown.

  ## Examples
      iex> alias Pathika.Ehex
      Pathika.Ehex
      iex> Ehex.from_ehex("Z")
      33
      iex> Ehex.from_ehex("0")
      0
      iex> Ehex.from_ehex("?")
      :unknown
      iex> Ehex.from_ehex("foo")
      :unknown
  """
  def from_ehex("?"), do: :unknown

  def from_ehex(rating) when is_binary(rating) and byte_size(rating) == 1,
    do: Map.get(inverse_ehex(), rating, :unknown)

  def from_ehex(_rating), do: :unknown

  defp ehex do
    values =
      Enum.map(0..9, fn x -> to_string(x) end)
      |> Enum.concat(Enum.map(?A..?Z, fn x -> <<x::utf8>> end))
      |> Enum.filter(fn x -> x not in ["I", "O"] end)

    Enum.zip(0..33, values)
    |> Enum.into(%{})
    |> Map.put(:unknown, "?")
  end

  defp inverse_ehex do
    Map.new(ehex(), fn {key, val} -> {val, key} end)
  end
end
