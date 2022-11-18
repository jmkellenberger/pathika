defmodule Pathika.HexGrid do
  @size 40
  @width 2 * @size
  @height :math.sin(:math.pi() / 3) * @size * 2

  @spec new(pos_integer, pos_integer) :: [{binary, binary}]
  def new(col, row) do
    grid = coordinates(col, row)

    Enum.map(grid, fn x ->
      coord = coordinate_to_string(x)
      hex = draw_hex(center_point(x))
      {coord, hex}
    end)
  end

  @spec draw_hex({number, number}) :: binary
  def draw_hex({center_x, center_y}) do
    hex_corner = fn i ->
      {center_x + @size * :math.cos(:math.pi() / 3 * i),
       center_y + @size * :math.sin(:math.pi() / 3 * i)}
    end

    0..5 |> Enum.map_join(" ", fn i -> hex_corner.(i) |> point_to_string() end)
  end

  @spec center_point({number, number} | binary) :: {float, float}
  def center_point({col, row}) do
    {@size + (col - 1) * @width * 0.75, row * @height - vertical_offset(col)}
  end

  def center_point(hex) when is_binary(hex) do
    {col, row} = string_to_coordinate(hex)
    {@size + (col - 1) * @width * 0.75, row * @height - vertical_offset(col)}
  end

  @spec coordinates(pos_integer, pos_integer) :: [{pos_integer, pos_integer}]
  def coordinates(col, row) do
    for x <- 1..col, y <- 1..row, do: {x, y}
  end

  @spec coordinate_to_string({integer, integer}) :: binary
  def coordinate_to_string({col, row}) do
    [col, row] |> Enum.map_join(fn n -> Integer.to_string(n) |> String.pad_leading(2, "0") end)
  end

  @spec string_to_coordinate(binary) :: {integer, integer}
  def string_to_coordinate(hex_number) do
    [x, y | _] = for <<x::binary-2 <- hex_number>>, do: x |> String.to_integer()

    {x, y}
  end

  defp point_to_string({x, y}), do: "#{x}, #{y}"

  defp vertical_offset(col) do
    case rem(col, 2) do
      0 -> 0
      _ -> @height / 2
    end
  end
end
