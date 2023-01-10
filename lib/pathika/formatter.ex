defmodule Pathika.Formatter do
  @doc """
  Converts an integer to T5 expanded hexadecimal.
  """
  def to_ehex(rating) do
    Map.get(ehex(), rating, "(#{rating})")
  end

  defp ehex() do
    values =
      Enum.map(0..9, fn x -> to_string(x) end)
      |> Enum.concat(Enum.map(?A..?Z, fn x -> <<x::utf8>> end))
      |> Enum.filter(fn x -> x not in ["I", "O"] end)

    Enum.zip(0..33, values)
    |> Enum.into(%{})
  end

  @doc """
  Adds commas to large values.
  """
  def format_number(n) do
    n
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
  end

  def format_world(world) do
    attributes =
      [
        world.size,
        world.atmosphere,
        world.hydrographics,
        world.population,
        world.government,
        world.law,
        world.tech
      ]
      |> Enum.map(fn n -> to_ehex(n) end)
      |> List.insert_at(6, "-")
      |> Enum.join()

    "#{world.name} #{world.port}#{attributes}"
  end
end
