defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view

  def mount(_, _, socket) do
    grid = hex_grid(8, 10)

    {:ok, assign(socket, :hex_grid, grid)}
  end

  def render(assigns) do
    ~H"""
    <div class="map-container">
    <svg width="1000" height="1000" viewBox="0 0 1000 1000">
      <g class="hex_map">
      <%= for {coord, points} <- @hex_grid do %>
        <polygon phx-click={"select-" <> coord} points={points} stroke="white" color="white">
          <%= coord %>
        </polygon>
      <% end %>
      </g>
    </svg>
    </div>
    """
  end

  def handle_event("select-" <> hex_number, _, socket) do
    IO.inspect(hex_number)
    {:noreply, socket}
  end

  def hex_grid(col, row) do
    size = 25
    width = 2 * size
    height = :math.sin(:math.pi() / 3) * size * 2

    vertical_offset = fn col ->
      case rem(col, 2) do
        0 -> 0
        _ -> height / 2
      end
    end

    center_point = fn {col, row} ->
      {size + col * width * 0.75, size + row * height + vertical_offset.(col)}
    end

    coordinates = for x <- 0..(col - 1), y <- 0..(row - 1), do: {x, y}

    coord_to_string = fn {x, y} ->
      [x, y] |> Enum.map_join(fn n -> Integer.to_string(n + 1) |> String.pad_leading(2, "0") end)
    end

    coordinates
    |> Enum.map(fn x -> {coord_to_string.(x), hexagon(center_point.(x), size)} end)
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
