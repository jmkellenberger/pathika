defmodule Pathika.Sector do
  alias Pathika.{HexGrid, Math, WorldGen}

  @spec random_sector(1..6, {pos_integer, pos_integer}) :: [%WorldGen.World{}]
  def random_sector(system_chance, {cols, rows} = grid_size)
      when system_chance in 1..6 and cols > 0 and rows > 0 do
    grid_size
    |> HexGrid.coordinates()
    |> Enum.reduce(%{}, fn coord, acc ->
      hex = HexGrid.coordinate_to_string(coord)

      case world_present?(system_chance) do
        true ->
          Map.put(acc, hex, WorldGen.build(:main, hex: hex))

        _ ->
          acc
      end
    end)
  end

  defp world_present?(system_chance) do
    Math.roll() >= system_chance
  end
end
