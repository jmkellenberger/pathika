defmodule Pathika.WorldGen do
  alias Pathika.WorldGen.{Descriptions, World}

  def build(type \\ Enum.random([:main, :other]), opts \\ [])

  def build(:main, opts) do
    World.world_generator(:mainworld, opts)
  end

  def build(:other, opts) do
    zone = Keyword.get(opts, :zone, World.random_orbital_zone())
    type = Keyword.get(opts, :type, World.random_world_type(zone))

    World.world_generator(type, opts)
  end

  def get_description(world) do
    {_, description} = Descriptions.detailed_world_description(world)
    description
  end
end
