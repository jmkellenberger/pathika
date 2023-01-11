defmodule PathikaWeb.ModalComponent do
  use PathikaWeb, :live_component
  def render(assigns) do
    ~H"""
      <div class="phx-modal" phx-window-keydown="close-modal" phx-key="escape" phx-capture-click="close-modal">
        <div class="phx-modal-content">
          <a href="#" phx-click="close-modal" class="phx-modal-close">
            &times;
          </a>
          <%= apply_action(@action) %>
        </div>
      </div>
    """
  end

  defp apply_action({:new, systems, hex}) do
    world = Pathika.WorldGen.build(:main, hex: hex)
    live_component(PathikaWeb.FormComponent, systems: systems, world: world)
  end

  defp apply_action({:show, world, _systems}) do
    live_component(PathikaWeb.SystemComponent, Pathika.WorldGen.get_description(world))
  end

  defp apply_action({:edit, systems, hex}) do
    live_component(PathikaWeb.FormComponent, systems: systems, world: systems[hex])
  end
end
