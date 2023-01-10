defmodule PathikaWeb.WorldGenController do
  use PathikaWeb, :controller

  alias Pathika.WorldGen

  def index(conn, _params) do
    world = WorldGen.build(:main)
    description = WorldGen.get_description(world)

    render(conn, "index.html", description)
  end
end
