defmodule Pathika.WorldGen.World do
  alias Pathika.{Math, Names}

  defstruct [
    :type,
    :name,
    :port,
    :size,
    :atmosphere,
    :hydrographics,
    :population,
    :government,
    :law,
    :tech
  ]

  def world_generator(type, opts) do
    {world, _} =
      {%__MODULE__{type: type}, opts}
      |> set_name()
      |> set_population()
      |> set_port()
      |> set_size()
      |> set_atmosphere()
      |> set_hydrographics()
      |> set_government()
      |> set_law()
      |> set_tech()

    world
  end

  def random_orbital_zone() do
    if Math.roll() > 3 do
      :outer
    else
      :inner
    end
  end

  def random_world_type(:outer) do
    case Math.roll() do
      1 -> :worldlet
      2 -> :iceworld
      3 -> :bigworld
      4 -> :iceworld
      5 -> :radworld
      6 -> :iceworld
    end
  end

  def random_world_type(:inner) do
    case Math.roll() do
      1 -> :inferno
      2 -> :innerworld
      3 -> :bigworld
      4 -> :stormworld
      5 -> :radworld
      6 -> :hospitable
    end
  end

  defp set_name({world, opts}) do
    name = Keyword.get(opts, :name, Names.random_world_name())
    world = %__MODULE__{world | name: name}

    {world, opts}
  end

  defp set_port({world, opts}) do
    port = Keyword.get(opts, :port, random_port(world))
    world = %__MODULE__{world | port: port}

    {world, opts}
  end

  defp random_port(world) when world.type == :mainworld do
    ["A", "A", "A", "B", "B", "C", "C", "D", "E", "E", "X"]
    |> Enum.at(Math.roll(2) - 2)
  end

  defp random_port(world) when world.type == :inferno do
    "Y"
  end

  defp random_port(world) do
    roll = world.population - Math.roll()

    case roll do
      n when n > 3 -> "F"
      3 -> "G"
      n when n > 0 -> "H"
      _ -> "Y"
    end
  end

  defp set_size({world, opts}) do
    size = Keyword.get(opts, :size, random_size(world.type))
    world = %__MODULE__{world | size: size}

    {world, opts}
  end

  defp random_size(type) when type in [:radworld, :stormworld] do
    Math.roll(2)
  end

  defp random_size(:inferno) do
    6 + Math.roll()
  end

  defp random_size(:bigworld) do
    (7 + Math.roll(2)) |> Math.clamp(0, 15)
  end

  defp random_size(:worldlet) do
    (Math.roll() - 3) |> Math.clamp(0, 15)
  end

  defp random_size(_type) do
    roll = Math.roll(2) - 2

    if roll == 10 do
      Math.roll() + 9
    else
      roll
    end
  end

  defp set_atmosphere({world, opts}) do
    value = Keyword.get(opts, :size, random_atmosphere(world))
    world = %__MODULE__{world | atmosphere: value}

    {world, opts}
  end

  defp random_atmosphere(world) when world.type == :inferno do
    11
  end

  defp random_atmosphere(world) when world.size == 0 do
    0
  end

  defp random_atmosphere(world) when world.type == :stormworld do
    (Math.flux() + world.size + 4)
    |> Math.clamp(0, 15)
  end

  defp random_atmosphere(world) do
    (Math.flux() + world.size)
    |> Math.clamp(0, 15)
  end

  defp set_hydrographics({world, opts}) do
    value = Keyword.get(opts, :hydrographics, random_hydrographics(world))
    world = %__MODULE__{world | hydrographics: value}

    {world, opts}
  end

  defp random_hydrographics(world) when world.size < 2 or world.type == :inferno do
    0
  end

  defp random_hydrographics(world) do
    (Math.flux() + world.atmosphere - hydrographics_mod(world))
    |> Math.clamp(0, 10)
  end

  defp hydrographics_mod(world) do
    if world.atmosphere <= 2 or world.atmosphere >= 9 or world.type in [:stormworld, :innerworld] do
      -4
    else
      0
    end
  end

  defp set_population({world, opts}) when world.type == :mainworld do
    value = Keyword.get(opts, :population, random_population(world))

    world = %__MODULE__{world | population: value}

    {world, opts}
  end

  defp set_population({world, opts}) do
    mw_pop = Keyword.get(opts, :mw_pop, random_population(world))

    value =
      Keyword.get(opts, :population, random_population(world))
      |> clamp_population(mw_pop, world)

    world = %__MODULE__{world | population: value}

    {world, opts}
  end

  defp random_population(world) when world.type in [:radworld, :inferno] do
    0
  end

  defp random_population(_world) do
    roll = Math.roll(2) - 2

    if roll == 10 do
      Math.roll(2) + 3
    else
      roll
    end
    |> Math.clamp(0, 15)
  end

  defp clamp_population(population, mw_pop, world) do
    mod = population_mod_by_type(world.type)
    max = max(mw_pop - 1, 0)
    (population - mod) |> Math.clamp(0, max)
  end

  defp population_mod_by_type(type) do
    case type do
      type when type in [:stormworld, :iceworld] -> 6
      :inner_world -> -4
      _ -> 0
    end
  end

  defp set_government({world, opts}) do
    value = Keyword.get(opts, :government, random_government(world))
    world = %__MODULE__{world | government: value}

    {world, opts}
  end

  defp random_government(world) when world.type in [:radworld, :inferno] do
    0
  end

  defp random_government(world) do
    (Math.flux() + world.population)
    |> Math.clamp(0, 15)
  end

  defp set_law({world, opts}) do
    value = Keyword.get(opts, :law, random_law(world))
    world = %__MODULE__{world | law: value}

    {world, opts}
  end

  defp random_law(world) when world.type in [:radworld, :inferno] do
    0
  end

  defp random_law(world) do
    (Math.flux() + world.government)
    |> Math.clamp(0, 18)
  end

  defp set_tech({world, opts}) do
    value = Keyword.get(opts, :tech, random_tech(world))
    world = %__MODULE__{world | tech: value}

    {world, opts}
  end

  defp random_tech(world) when world.type in [:radworld, :inferno] do
    0
  end

  defp random_tech(world) do
    (Math.roll() + get_tech_mod(world))
    |> Math.clamp(0, 33)
  end

  defp get_tech_mod(world) do
    [:port, :size, :atmosphere, :hydrographics, :population, :government]
    |> Enum.map(&get_value(world, &1))
    |> Enum.map(&tech_mod/1)
    |> Enum.sum()
  end

  defp get_value(map, key) do
    value = Map.get(map, key, 0)

    case value do
      nil -> {key, 0}
      _ -> {key, value}
    end
  end

  defp tech_mod({:port, value}) do
    case value do
      "A" ->
        6

      "B" ->
        4

      "C" ->
        2

      "J" ->
        1

      "X" ->
        -4

      _ ->
        0
    end
  end

  defp tech_mod({:size, value}) do
    case value do
      0 ->
        2

      n when n in 1..4 ->
        1

      _ ->
        0
    end
  end

  defp tech_mod({:atmosphere, value}) do
    case value do
      n when n in 0..3 ->
        1

      n when n in 10..15 ->
        1

      _ ->
        0
    end
  end

  defp tech_mod({:hydrographics, value}) do
    case value do
      9 ->
        1

      10 ->
        2

      _ ->
        0
    end
  end

  defp tech_mod({:population, value}) do
    case value do
      n when n in 1..5 ->
        1

      9 ->
        2

      n when n in 10..15 ->
        4

      _ ->
        0
    end
  end

  defp tech_mod({:government, value}) do
    case value do
      0 ->
        1

      5 ->
        1

      13 ->
        -2

      _ ->
        0
    end
  end
end
