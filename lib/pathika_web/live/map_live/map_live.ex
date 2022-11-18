defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexGrid
  alias Pathika.Names

  def mount(_, _, socket) do
    grid = HexGrid.new(8, 10)

    subsector =
      HexGrid.coordinates(8, 10)
      |> Enum.map(&HexGrid.coordinate_to_string/1)
      |> Map.new(&{&1, nil})

    socket =
      assign(socket,
        hex_grid: grid,
        page_title: "SectorMaker",
        subsector: subsector
      )

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
            <polygon class="hex" id={"hex-" <> coord} points={hex} stroke="gray" fill="black"/>
        <% end %>
        <%= for {hex, system} <- Enum.filter(@subsector, fn {_k, v} -> v end) do %>
          <% {x, y} = HexGrid.center_point(hex) %>
          <circle class="click-through" cx={x} cy={y} fill="white" r="8"/>
          <text class="click-through" text-anchor="middle" x={x} y={y - 23} fill="white" font-family="Optima,  sans-serif", font-size="x-small" > <%= hex %> </text>
          <text class="click-through" text-anchor="middle" x={x} y={y + 25} fill="white" font-family="Optima,  sans-serif", font-size="smaller" > <%= system %> </text>
        <% end %>
        </g>
      </svg>
    </div>
    """
  end

  def handle_event(
        "select",
        %{"target" => "hex-" <> hex_number, "altKey" => false},
        socket
      ) do
    subsector =
      Map.update(socket.assigns.subsector, hex_number, nil, fn system ->
        case system do
          nil -> Names.random_world_name()
          _ -> system
        end
      end)

    socket = assign(socket, subsector: subsector)

    {:noreply, socket}
  end

  def handle_event("select", %{"target" => "hex-" <> hex_number, "altKey" => true}, socket) do
    subsector = Map.put(socket.assigns.subsector, hex_number, nil)

    socket = assign(socket, subsector: subsector)

    {:noreply, socket}
  end

  def handle_event("select", %{"target" => _}, socket) do
    {:noreply, socket}
  end
end
