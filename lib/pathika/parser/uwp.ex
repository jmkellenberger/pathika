defmodule Pathika.Parser.UWP do
  @moduledoc """
  Constructs Universal World Profiles
  """
  alias Pathika.Ehex

  defstruct port: :unknown,
            size: :unknown,
            atmosphere: :unknown,
            hydrographics: :unknown,
            population: :unknown,
            government: :unknown,
            law: :unknown,
            tech: :unknown

  @type t() :: %__MODULE__{
          port: :unknown | :A | :B | :C | :D | :E | :X | :F | :G | :H | :Y,
          size: :unknown | 0..15,
          atmosphere: :unknown | 0..15,
          hydrographics: :unknown | 0..10,
          population: :unknown | 0..15,
          government: :unknown | 0..15,
          law: :unknown | 0..18,
          tech: :unknown | 0..33
        }

  @world_types [
    :main,
    :hospitable,
    :planetoid,
    :worldlet,
    :inferno,
    :inner,
    :big,
    :storm,
    :ice,
    :rad
  ]

  @spec new(
          String.t(),
          :big
          | :hospitable
          | :ice
          | :inferno
          | :inner
          | :main
          | :planetoid
          | :rad
          | :storm
          | :worldlet
        ) ::
          {:error,
           :invalid_atmosphere
           | :invalid_government
           | :invalid_hydrographics
           | :invalid_law_level
           | :invalid_population
           | :invalid_port
           | :invalid_size
           | :invalid_tech_level
           | :invalid_uwp_length}
          | {:ok, Pathika.Parser.UWP.t()}
  @doc """
  Constructs a Universal World Profile from an alphanumeric string and optional
  world type atom.

  ### World Types:
          :main,
          :hospitable,
          :planetoid,
          :worldlet,
          :inferno,
          :storm,
          :inner,
          :big
          :ice,
          :rad


  ## Examples
      iex> alias Pathika.Parser.UWP
      Pathika.Parser.UWP
      iex> world = "A788899-C"
      "A788899-C"
      iex> UWP.new(world)
      {:ok,
      %Pathika.Parser.UWP{
      port: :A,
      size: 7,
      atmosphere: 8,
      hydrographics: 8,
      population: 8,
      government: 9,
      law: 9,
      tech: 12
      }}

      iex> alias Pathika.Parser.UWP
      Pathika.Parser.UWP
      iex> world = "F788899-6"
      "F788899-6"
      iex> UWP.new(world, :inferno)
      {:error, :invalid_port}
  """
  def new(input, type \\ :main)

  def new(input, type)
      when is_binary(input) and byte_size(input) == 9 and
             type in @world_types do
    input = String.split(input, "", trim: true)

    case parse_uwp(input, type) do
      {:ok, uwp} -> {:ok, struct(__MODULE__, uwp)}
      error -> error
    end
  end

  def new(input, type)
      when is_binary(input) and
             type in @world_types,
      do: {:error, :invalid_uwp_length}

  defp parse_uwp([head | tail], type) do
    with {:ok, port} <- parse_port(head),
         {:ok, attributes} <- parse_attributes(tail),
         {:ok, uwp} <- validate_uwp([port | attributes], type) do
      {:ok, uwp}
    else
      err -> err
    end
  end

  defp parse_port("?"), do: {:ok, :unknown}

  defp parse_port(input) do
    port = String.upcase(input)
    ports = ~w(A B C D E F G H Y X)

    if port in ports do
      {:ok, String.to_atom(port)}
    else
      {:error, :invalid_port}
    end
  end

  defp parse_attributes(input) do
    attributes =
      input
      |> Enum.reject(&(&1 == "-"))
      |> Enum.map(&Ehex.from_ehex/1)

    case length(attributes) do
      7 -> {:ok, attributes}
      _ -> {:error, :invalid_uwp_length}
    end
  end

  defp zip_attributes(uwp) do
    [
      :port,
      :size,
      :atmosphere,
      :hydrographics,
      :population,
      :government,
      :law,
      :tech
    ]
    |> Enum.zip(uwp)
    |> Map.new()
  end

  defp validate_uwp(attributes, type) do
    with uwp <- zip_attributes(attributes),
         {:ok, uwp} <- validate_port(uwp, type),
         {:ok, uwp} <- validate_size(uwp, type),
         {:ok, uwp} <- validate_atmosphere(uwp, type),
         {:ok, uwp} <- validate_hydrographics(uwp, type),
         {:ok, uwp} <- validate_population(uwp, type),
         {:ok, uwp} <- validate_government(uwp, type),
         {:ok, uwp} <- validate_law(uwp, type),
         {:ok, uwp} <- validate_tech(uwp, type) do
      {:ok, uwp}
    else
      err -> err
    end
  end

  defp validate_port(uwp, type) do
    case port_valid?(uwp, type) do
      true ->
        {:ok, uwp}

      false ->
        {:error, :invalid_port}
    end
  end

  defp port_valid?(%{port: :unknown}, _type), do: true
  defp port_valid?(uwp, :inferno), do: uwp.port == :Y
  defp port_valid?(uwp, :main), do: uwp.port in [:A, :B, :C, :D, :E, :X]

  defp port_valid?(%{port: port}, _type)
       when port in [:A, :B, :C, :D, :E, :X],
       do: false

  defp port_valid?(%{port: :F, population: pop}, _type) when pop > 5, do: true
  defp port_valid?(%{port: :G, population: pop}, _type) when pop > 4, do: true
  defp port_valid?(%{port: :H, population: pop}, _type) when pop > 0, do: true
  defp port_valid?(%{port: :Y}, _type), do: true

  defp port_valid?(_uwp, _type), do: false

  defp validate_size(%{size: :unknown} = uwp, _type), do: {:ok, uwp}

  defp validate_size(%{size: size} = uwp, type) do
    {min, max} = size_range(type)

    if size in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_size}
    end
  end

  defp size_range(:planetoid), do: {0, 0}
  defp size_range(:worldlet), do: {0, 3}
  defp size_range(:inferno), do: {7, 12}
  defp size_range(:big), do: {9, 15}
  defp size_range(type) when type in [:storm, :rad], do: {2, 12}
  defp size_range(_type), do: {0, 15}

  defp validate_atmosphere(%{atmosphere: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_atmosphere(%{atmosphere: atmo} = uwp, type) do
    {min, max} = atmosphere_range(uwp, type)

    if atmo in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_atmosphere}
    end
  end

  defp atmosphere_range(%{size: 0}, _type), do: {0, 0}
  defp atmosphere_range(_uwp, :planetoid), do: {0, 0}
  defp atmosphere_range(_uwp, :inferno), do: {11, 11}
  defp atmosphere_range(%{size: :unknown}, :storm), do: {1, 15}
  defp atmosphere_range(%{size: :unknown}, _type), do: {0, 15}

  defp atmosphere_range(uwp, type) do
    mods = atmos_modifier(uwp, type)
    {max(0, mods - 5), min(mods + 5, 15)}
  end

  defp atmos_modifier(%{size: size}, :storm), do: 4 + size
  defp atmos_modifier(uwp, _type), do: uwp.size

  defp validate_hydrographics(%{hydrographics: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_hydrographics(%{hydrographics: hydro} = uwp, type) do
    {min, max} = hydrographics_range(uwp, type)

    if hydro in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_hydrographics}
    end
  end

  defp hydrographics_range(%{size: size}, _type) when size < 2, do: {0, 0}
  defp hydrographics_range(_uwp, :inferno), do: {0, 0}

  defp hydrographics_range(uwp, type) do
    mods =
      hydro_atmos_mod(uwp) + hydro_type_mod(type) +
        hydro_unknown_adjust(uwp)

    {max(0, mods - 5), min(mods + 5, 10)}
  end

  defp hydro_atmos_mod(%{atmosphere: :unknown}), do: 0

  defp hydro_atmos_mod(%{atmosphere: atmo}) when atmo < 2 or atmo > 9,
    do: atmo - 4

  defp hydro_atmos_mod(%{atmosphere: atmo}), do: atmo

  defp hydro_unknown_adjust(%{atmosphere: :unknown, size: :unknown}), do: 5
  defp hydro_unknown_adjust(_uwp), do: 0

  defp hydro_type_mod(type) when type in [:inner, :storm], do: -4
  defp hydro_type_mod(_type), do: 0

  defp validate_population(%{population: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_population(%{population: pop} = uwp, type) do
    {min, max} = population_range(type)

    if pop in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_population}
    end
  end

  defp population_range(type) when type in [:rad, :inferno], do: {0, 0}
  defp population_range(type) when type in [:ice, :storm], do: {0, 4}
  defp population_range(:inner), do: {0, 6}
  defp population_range(:main), do: {0, 15}
  defp population_range(_type), do: {0, 9}

  defp validate_government(%{government: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_government(%{government: govt} = uwp, type) do
    {min, max} = government_range(uwp, type)

    if govt in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_government}
    end
  end

  defp government_range(_uwp, type) when type in [:inferno, :rad], do: {0, 0}
  defp government_range(%{population: 0}, _type), do: {0, 0}
  defp government_range(%{population: :unknown}, _type), do: {0, 18}

  defp government_range(%{population: pop}, _type),
    do: {max(0, pop - 5), min(15, pop + 5)}

  defp validate_law(%{law: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_law(%{law: law} = uwp, type) do
    {min, max} = law_range(uwp, type)

    if law in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_law_level}
    end
  end

  defp law_range(%{population: 0}, _type), do: {0, 0}
  defp law_range(%{government: :unknown}, _type), do: {0, 18}
  defp law_range(%{government: 0}, _type), do: {0, 0}

  defp law_range(%{government: govt}, _type),
    do: {max(0, govt - 5), min(18, govt + 5)}

  defp validate_tech(%{tech: :unknown} = uwp, _type),
    do: {:ok, uwp}

  defp validate_tech(%{tech: tech} = uwp, type) do
    {min, max} = tech_range(uwp, type)

    if tech in min..max do
      {:ok, uwp}
    else
      {:error, :invalid_tech_level}
    end
  end

  defp tech_range(_uwp, type) when type in [:inferno, :rad], do: {0, 0}

  defp tech_range(uwp, _type) do
    tech_mods = sum_tech_mods(uwp)
    {max(tech_mods + 1, 0), min(tech_mods + 6, 33)}
  end

  defp sum_tech_mods(uwp) do
    uwp
    |> Enum.map(fn {k, v} -> Map.get(Map.get(tech_mods(), k, %{}), v, 0) end)
    |> Enum.sum()
  end

  defp tech_mods,
    do: %{
      port: %{A: 6, B: 4, C: 2, F: 1, X: -4},
      size: %{0 => 2, 1 => 2, 2 => 1, 3 => 1, 4 => 1},
      atmosphere: %{
        0 => 1,
        1 => 1,
        2 => 1,
        3 => 1,
        10 => 1,
        11 => 1,
        12 => 1,
        13 => 1,
        14 => 1,
        15 => 1
      },
      hydrographics: %{9 => 1, 10 => 2},
      population: %{1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 9 => 2, 10 => 4},
      government: %{0 => 1, 5 => 1, 13 => -1}
    }
end
