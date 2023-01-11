defmodule PathikaWeb.MapLive do
  use PathikaWeb, :live_view
  alias Pathika.HexGrid
  alias Pathika.Sector
  alias Pathika.Parser

  @grid_size {8, 10}
  @grid HexGrid.new(@grid_size)
  @system_chance 5

  def mount(_, _, socket) do
    system_chance = @system_chance
    systems = Sector.random_sector(system_chance, @grid_size)

    socket =
      assign(socket,
        hex_grid: @grid,
        page_title: "Map Editor",
        systems: systems,
        show_modal: false
      )

    {:ok, socket}
  end

  def handle_event("select", %{"target" => "hex-" <> hex}, socket) do
    world = socket.assigns.systems[hex]

    socket = case world do
      nil ->
        assign(socket, :action, {:new, socket.assigns.systems})
      _ -> assign(socket, action: {:show, world, socket.assigns.systems}, show_modal: true)
    end

    socket = assign(socket, hex: hex)

    {:noreply, socket}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, close_modal(socket)}
  end

  def handle_event("update", %{"sector" => data}, socket) do
    case Parser.parse_system_data(data["data"]) do
      {:error, error} ->
        IO.inspect(error)
        {:noreply, socket}
      systems -> {:noreply, assign(socket, :systems, systems)}
    end
  end

  defp close_modal(socket) do
    assign(socket, :show_modal, false)
  end
end
