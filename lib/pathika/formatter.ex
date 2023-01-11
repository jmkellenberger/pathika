defmodule Pathika.Formatter do
  @moduledoc """
  Helper functions in converting World and Sector data to strings.
  TODO: Most of these could probably be implemented through the String.Chars protocol.
  """
  @doc """
  Converts an integer to T5 expanded hexadecimal.
  """
  def to_ehex(rating) do
    Map.get(ehex(), rating, "(#{rating})")
  end

  defp ehex() do
    values =
      Enum.map(0..9, fn x -> to_string(x) end)
      |> Enum.concat(Enum.map(?A..?Z, fn x -> <<x::utf8>> end))
      |> Enum.filter(fn x -> x not in ["I", "O"] end)

    Enum.zip(0..33, values)
    |> Enum.into(%{})
  end

  @doc """
  Adds commas to large values.
  """
  def format_number(n) do
    n
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
  end

  def format_world(world) do
    attributes =
      [
        world.size,
        world.atmosphere,
        world.hydrographics,
        world.population,
        world.government,
        world.law,
        world.tech
      ]
      |> Enum.map(fn n -> to_ehex(n) end)
      |> List.insert_at(6, "-")
      |> Enum.join()

    "#{world.port}#{attributes}"
  end

  def base_code(bases) do
    case bases do
      %{naval: true, scout: true} -> "NS"
      %{naval: true, scout: false} -> "N"
      %{naval: false, scout: true} -> "S"
      %{naval: false, scout: false} -> " "
    end
  end

  def travel_zone(system) do
    case system.travel_zone do
      :green -> " "
      :red -> "R"
      :amber -> "A"
    end
  end

  def pbg(%{pbg: %{population_digit: pop, belts: belts, gas_giants: gas_giants}}) do
    "#{pop}#{belts}#{gas_giants}"
  end

  @doc """
  Formats a group of systems according to the T5 Second Survey data format, organized by hex number.
  """
  def format_sector(systems) do
    max_name_length = get_max_name_length(systems)
    {labels, separator} = header(max_name_length)

    systems = Enum.map(systems, &format_system(&1, max_name_length) |> String.pad_trailing(String.length(separator)))

    [labels, separator | systems] |> Enum.join("\n")
  end

  defp get_max_name_length(systems) do
    Enum.reduce(systems, 0, fn system, acc ->
      name_length = String.length(system.name)
      case name_length > acc do
        true -> name_length
        _ -> acc
      end
    end)
  end

  defp header(name_length) do
    labels = "Hex  #{String.pad_trailing("Name", name_length)} UWP       B Z PBG Remarks {Ix} (Ex) [Cx] N W A Stellar"
    separator = "____ #{String.pad_trailing("_", name_length, "_")} _________ _ _ ___ _______ ____ ____ ____ _ _ _ _______"
    {labels, separator}
  end

  @doc """
  TODO: Currently only implments Hex number, Name, UWP, Bases, Travel Zone, and PBG.
  """
  def format_system(system, name_length) do
    "#{system.hex} #{String.pad_trailing(system.name, name_length)} #{format_world(system)} #{base_code(system.bases)} #{travel_zone(system)} #{pbg(system)}"
  end
end
