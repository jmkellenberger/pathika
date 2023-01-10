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
