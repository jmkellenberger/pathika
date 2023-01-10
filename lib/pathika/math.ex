defmodule Pathika.Math do
  @doc """
  Returns the sum of a quantity of 6-sided die rolls
  """
  def roll(quantity) when quantity > 0 do
    Enum.reduce(1..quantity, 0, fn _, acc -> :rand.uniform(6) + acc end)
  end

  @doc """
  Returns the result of a 6 sided die
  """
  def roll() do
    :rand.uniform(6)
  end

  @doc """
  Traveller5 flux roll. Returns the difference of two six sided die rolls.
  """
  def flux(), do: roll() - roll()

  @doc """
  Constrains a number to a min and max value.
  """
  def clamp(n, _min, max) when n > max, do: max
  def clamp(n, min, _max) when n < min, do: min
  def clamp(n, _min, _max), do: n
end
