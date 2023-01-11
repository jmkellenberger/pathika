defmodule Pathika.Math do
  @spec roll :: 1..6
  @doc """
  Returns the result of a 6 sided die
  """
  def roll() do
    :rand.uniform(6)
  end

  @spec roll(pos_integer) :: pos_integer()
  @doc """
  Returns the sum of a quantity of 6-sided die rolls
  """
  def roll(quantity) when quantity > 0 do
    Enum.reduce(1..quantity, 0, fn _, acc -> roll() + acc end)
  end

  @spec rolls(pos_integer, pos_integer) :: [pos_integer()]
  def rolls(number, sides \\ 6)
      when is_integer(number) and is_integer(sides) and sides > 1 and number > 0 do
    1..number
    |> Enum.map(fn _ -> roll(sides) end)
  end

  @spec flux :: -5..5
  @doc """
  Traveller5 flux roll. Returns the difference of two six sided die rolls.
  """
  def flux(), do: roll() - roll()

  @doc """
  Constrains a number to a range
  """
  def clamp(num, min..max), do: clamp(num, min, max)

  @doc """
  Constrains a number to a min and max value.
  """
  def clamp(num, _min, max) when num > max, do: max
  def clamp(num, min, _max) when num < min, do: min
  def clamp(num, _min, _max), do: num
end
