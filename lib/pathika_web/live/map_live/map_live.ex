defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexMap

  def mount(_, _, socket) do
    grid = HexMap.hex_grid(3, 3)

    {:ok, assign(socket, :hex_grid, grid)}
  end

  def render(assigns) do
    ~H"""
    <style>
      .hex:hover {
        fill: gray;
        transition: all ease 0.3s;
      }
      .hex: {
        transition: all ease 0.3s;
      }
    </style>
    <div class="map-container">
      <svg width="1000" height="1000" viewBox="0 0 1000 1000">
        <g id="hex_map">
        <%= for {coord, hex} <- @hex_grid do %>
          <polygon class="hex" id={coord} phx-click={"select-" <> coord} points={hex.points} stroke="gray" fill="black"/>
          <%= if hex.contents do %>
          <circle phx-click={"select-" <> coord} cx={hex.center_x} cy={hex.center_y} fill="white" r="8"/>
          <text phx-click={"select-" <> coord} text-anchor="middle" x={hex.center_x} y={hex.center_y - 20} fill="white" > <%= coord%> </text>
          <% end %>
        <% end %>
        </g>
      </svg>
    </div>
    """
  end

  def handle_event("select-" <> hex_number, _, socket) do
    map = socket.assigns.hex_grid
    hex = Map.get(map, hex_number)
    hex = Map.put(hex, :contents, !hex.contents)

    hex_grid = %{map | hex_number => hex}
    {:noreply, assign(socket, :hex_grid, hex_grid)}
  end
end
