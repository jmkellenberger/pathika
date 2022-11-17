defmodule Pathika.HexMap do
  def hex_grid(col, row) do
    size = 40
    width = 2 * size
    height = :math.sin(:math.pi() / 3) * size * 2

    vertical_offset = fn col ->
      case rem(col, 2) do
        0 -> 0
        _ -> -height / 2
      end
    end

    center_point = fn {col, row} ->
      {size + col * width * 0.75, size + row * height + vertical_offset.(col)}
    end

    coordinates = for x <- 1..col, y <- 1..row, do: {x, y}

    coord_to_string = fn {x, y} ->
      [x, y] |> Enum.map_join(fn n -> Integer.to_string(n) |> String.pad_leading(2, "0") end)
    end

    coordinates
    |> Enum.map(fn x ->
      {center_x, center_y} = center_point.(x)

      %{
        coord: coord_to_string.(x),
        center_x: center_x,
        center_y: center_y,
        points: hexagon({center_x, center_y}, size)
      }
    end)
  end

  def hexagon({center_x, center_y}, size) do
    hex_corner = fn i ->
      {center_x + size * :math.cos(:math.pi() / 3 * i),
       center_y + size * :math.sin(:math.pi() / 3 * i)}
    end

    point_to_string = fn {x, y} -> "#{x}, #{y}" end

    0..5 |> Enum.map_join(" ", fn i -> hex_corner.(i) |> point_to_string.() end)
  end
end
