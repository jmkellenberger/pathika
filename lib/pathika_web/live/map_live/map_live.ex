defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexGrid
  alias Pathika.System

  def mount(_, _, socket) do
    grid = HexGrid.new(8, 10)

    socket =
      assign(socket,
        hex_grid: grid,
        page_title: "SectorMaker",
        systems: System.parse_data(System.sample())
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
      textarea {
        overflow-x: scroll;
        overflow-y: scroll;
        resize: none;
      }

    </style>
    <div id="wrapper">

      <div id="map-container">
        <svg id="hex-map" height="800px" viewBox="0 0 500 728">
          <g phx-click="select">
          <%= for {coord, hex} <- @hex_grid do %>
              <polygon class="hex" id={"hex-" <> coord} points={hex} stroke="gray" fill="black"/>
          <% end %>
          <%= for system <- @systems do %>
            <% {x, y} = HexGrid.center_point(system.hex) %>
            <%= if system.travel_zone == "A" do %>
            <circle class="click-through" cx={x} cy={y} stroke="orange" fill="none" r="30"/>
            <% end%>
            <%= if system.travel_zone == "R" do %>
            <circle class="click-through" cx={x} cy={y} stroke="red" fill="none" r="30"/>
            <% end%>
            <circle class="click-through" cx={x} cy={y} fill="white" r="5"/>
            <text class="click-through" text-anchor="middle" x={x} y={y - 23} fill="white" font-family="Optima,  sans-serif", font-size="x-small" > <%= system.hex %> </text>
            <text class="click-through" text-anchor="middle" x={x} y={y - 10} fill="white" font-family="Optima,  sans-serif", font-size="x-small" > <%= String.slice(system.uwp, 0..0) %> </text>
            <text class="click-through" text-anchor="middle" x={x} y={y + 25} fill="white" font-family="Optima,  sans-serif", font-size="smaller" > <%= system.name %> </text>
            <%= if system.bases == "N" do %>
              <text class="click-through" text-anchor="middle" x={x - 20} y={y} fill="white" font-family="Optima,  sans-serif", font-size="x-small" > <%= system.bases %> </text>
            <% end%>
          <% end %>
          </g>
        </svg>
      </div>
      <div id="data-input">
        <.form let={f} for={:sector} phx-change="update">
          <%= textarea f , :data, wrap: "off", cols: "80", rows: "10", spellcheck: "false", phx_debounce: "500", value: System.sample()%>
        </.form>
      </div>
    </div>
    """
  end

  # def handle_event(
  #       "select",
  #       %{"target" => "hex-" <> hex_number, "altKey" => false},
  #       socket
  #     ) do
  #   subsector =
  #     Map.update(socket.assigns.subsector, hex_number, nil, fn system ->
  #       case system do
  #         nil -> Names.random_world_name()
  #         _ -> system
  #       end
  #     end)

  #   socket = assign(socket, subsector: subsector)

  #   {:noreply, socket}
  # end

  def handle_event("update", %{"sector" => data}, socket) do
    systems = data["data"] |> System.parse_data()
    socket = assign(socket, :systems, systems)
    {:noreply, socket}
  end

  # def handle_event("select", %{"target" => "hex-" <> hex_number, "altKey" => true}, socket) do
  #   subsector = Map.put(socket.assigns.subsector, hex_number, nil)

  #   socket = assign(socket, subsector: subsector)

  #   {:noreply, socket}
  # end

  def handle_event("select", _, socket) do
    {:noreply, socket}
  end
end
