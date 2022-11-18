defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexMap

  def mount(_, _, socket) do
    grid = HexMap.hex_grid(8, 10)

    socket = assign(socket, hex_grid: grid, page_title: "SectorMaker")

    {:ok, socket}
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
      #hex-map {
        border-style: solid;
        border-color: grey;
        border-width: 3px;
        background-color: black;
      }
    </style>
    <div id="map-container">
      <svg id="hex-map" height="800px" viewBox="0 0 500 728">
        <g phx-click="select">
        <%= for {coord, hex} <- @hex_grid do %>
            <polygon class="hex" id={"hex-" <> coord} points={hex.points} stroke="white" fill="black"/>
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
    hex_grid =
      Map.update!(
        socket.assigns.hex_grid,
        hex_number,
        fn hex -> Map.put(hex, :contents, !hex.contents) end
      )

    socket = assign(socket, :hex_grid, hex_grid)

    {:noreply, socket}
  end

  def handle_event("select", %{"target" => _}, socket) do
    {:noreply, socket}
  end
end
