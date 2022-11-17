defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexMap

  def mount(_, _, socket) do
    grid = HexMap.hex_grid(3, 3)

    {:ok, assign(socket, :hex_grid, grid)}
  end

  def render(assigns) do
    ~H"""
    <div class="map-container">
      <svg width="1000" height="1000" viewBox="0 0 1000 1000">
        <g class="hex_map">
        <%= for hex <- @hex_grid do %>
          <polygon id={hex.coord} phx-click={"select-" <> hex.coord} points={hex.points} stroke="gray" fill="black"/>
          <text text-anchor="middle" x={hex.center_x} y={hex.center_y - 20} fill="white" > <%= hex.coord%> </text>
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
end
