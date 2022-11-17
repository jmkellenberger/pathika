defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexMap

  def mount(_, _, socket) do
    grid = HexMap.hex_grid(8, 10)

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
      .click-through {
        pointer-events: none;
      }
    </style>
    <div id="map-container">
      <svg width="1000" height="1000" viewBox="0 0 1000 1000">
        <g phx-click="select" id="hex_map">
        <%= for {coord, hex} <- @hex_grid do %>
            <polygon class="hex" id={"hex-" <> coord} points={hex.points} stroke="gray" fill="black"/>
            <%= if hex.contents do %>
            <circle class="click-through" cx={hex.center_x} cy={hex.center_y} fill="white" r="8"/>
            <text class="click-through" text-anchor="middle" x={hex.center_x} y={hex.center_y - 23} fill="white" font-family="monospace" > <%= coord %> </text>
            <% end %>
          <% end %>
        </g>
      </svg>
    </div>
    """
  end

  def handle_event("select", %{"target" => "hex-" <> hex_number}, socket) do
    map = socket.assigns.hex_grid
    hex = Map.get(map, hex_number)
    hex = Map.put(hex, :contents, !hex.contents)

    hex_grid = %{map | hex_number => hex}
    {:noreply, assign(socket, :hex_grid, hex_grid)}
  end

  def handle_event("select", %{"target" => _}, socket) do
    {:noreply, socket}
  end
end
