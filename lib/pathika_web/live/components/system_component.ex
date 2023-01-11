defmodule PathikaWeb.SystemComponent do
  use PathikaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <h2><%= "#{@world_name} (#{@uwp})" %></h2>
        <dl>
            <dt>Type</dt>
            <dd><%= @type %></dd>
            <dt>Starport</dt>
            <dd><%= @port %></dd>
            <dt>Size</dt>
            <dd><%= @size %></dd>
            <dt>Atmosphere</dt>
            <dd><%= @atmosphere %></dd>
            <dt>Hydrographics</dt>
            <dd><%= @hydrographics %></dd>
            <dt>Population</dt>
            <dd><%= @population %></dd>
            <dt>Government</dt>
            <dd><%= @government %></dd>
            <dt>Law Level</dt>
            <dd><%= @law %></dd>
            <dt>Tech Level</dt>
            <dd><%= @tech %></dd>
            <dt>Bases</dt>
            <dd><%= @bases %></dd>
            <dt>System Resources</dt>
            <dd><%= @belts_and_gas %></dd>
            <dt>Status of Native Intelligent Life</dt>
            <dd><%= @natives %></dd>
            <dt>Travel Advisory</dt>
            <dd><%= @travel_zone %></dd>
        </dl>
    </div>
    """
  end
end
