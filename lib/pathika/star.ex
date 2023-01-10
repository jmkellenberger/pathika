defmodule Pathika.Star do
  @moduledoc """
  Creates Primary Stars and their companions from T5 stellar data strings.
  """
  @enforce_keys [:type, :size]
  defstruct [:type, :size, :decimal]

  @type t :: %__MODULE__{
          type: String.t(),
          size: String.t(),
          decimal: String.t()
        }

  @star_types ["O", "B", "A", "F", "G", "K", "M", "BD"]
  @star_sizes ["Ia", "Ib", "II", "III", "IV", "V", "VI", "D"]
  @decimals ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  @spec new(input :: String.t()) ::
          {:error,
           :empty_input
           | :exceeds_max_stars
           | :incompatible_companion
           | :invalid_decimal
           | :invalid_primary_type
           | :invalid_size
           | :invalid_type}
          | {:ok, [Pathika.Star.t()]}
  @doc """
  Parses a space separated string of stellar data and returns a list of Stars.

  ### Input Format:
   * Stars separated by whitespace
   * Non-Dwarf Stars: SpectralTypeSpectralDecimal SpectralSize (G2 V)
   * Dwarf Stars: DSpectralType (DF, DM, DK)
   * Brown Dwarfs: BD

  ## Examples
      iex> alias Pathika.Star
      Pathika.Star
      iex>Star.new("F7 V DM M3 V")
      {:ok,
      [
      %Pathika.Star{type: "F", size: "V", decimal: "7"},
      %Pathika.Star{type: "M", size: "D", decimal: ""},
      %Pathika.Star{type: "M", size: "V", decimal: "3"}
      ]}
      iex>Star.new("BD F7 V M0 V")
      {:error, :invalid_primary_type}
  """

  def new(input) when is_binary(input) and byte_size(input) > 1 do
    stars =
      input
      |> String.trim()
      |> String.split(" ", trim: true)
      |> chunk_stars([])

    case stars do
      {:ok, stars} -> chunks_to_stars(stars, [])
      err -> err
    end
  end

  defp new_primary(input)
       when is_binary(input) and byte_size(input) > 1 do
    [head | tail] = String.split(input, " ", parts: 2, trim: true)

    with {:ok, parts} <- valid_head?(head, :primary),
         {:ok, star} <- valid_size?(tail, parts) do
      {:ok, %__MODULE__{type: star.type, size: star.size, decimal: star.decimal}}
    else
      err -> err
    end
  end

  defp new_companion(input, primary)
       when byte_size(input) > 1 and is_struct(primary, __MODULE__) do
    [head | tail] = String.split(input, " ", parts: 2, trim: true)

    with {:ok, parts} <- valid_head?(head, :companion),
         {:ok, parts} <- validate_companion_type(parts, primary),
         {:ok, star} <- valid_size?(tail, parts),
         {:ok, star} <- validate_companion_size(star, primary) do
      {:ok, %__MODULE__{type: star.type, size: star.size, decimal: star.decimal}}
    else
      err -> err
    end
  end

  defp chunk_stars([], []), do: {:error, :empty_input}
  defp chunk_stars([], stars), do: {:ok, Enum.reverse(stars)}

  defp chunk_stars(["BD" = star | rest], stars),
    do: chunk_stars(rest, [star | stars])

  defp chunk_stars(["D" <> _ = dwarf | rest], stars),
    do: chunk_stars(rest, [dwarf | stars])

  defp chunk_stars([head | tail], stars) do
    [next | rest] = tail

    case next do
      "BD" -> {:error, :invalid_size}
      "D" <> _ -> {:error, :invalid_size}
      _ -> chunk_stars(rest, ["#{head} #{next}" | stars])
    end
  end

  defp chunks_to_stars([], stars, _primary) when length(stars) > 8,
    do: {:error, :exceeds_max_stars}

  defp chunks_to_stars([], stars, _primary), do: {:ok, Enum.reverse(stars)}

  defp chunks_to_stars([head | tail], stars, primary) do
    case new_companion(head, primary) do
      {:ok, star} -> chunks_to_stars(tail, [star | stars], primary)
      err -> err
    end
  end

  defp chunks_to_stars([head | tail], []) do
    case new_primary(head) do
      {:ok, star} -> chunks_to_stars(tail, [star], star)
      err -> err
    end
  end

  defp valid_head?("BD", :primary),
    do: {:error, :invalid_primary_type}

  defp valid_head?("BD", _type),
    do: {:ok, %{type: "BD", size: "", decimal: ""}}

  defp valid_head?("D" <> star_type, _type) when star_type in @star_types,
    do: {:ok, %{size: "D", type: star_type, decimal: ""}}

  defp valid_head?(head, _type) do
    [type | decimal] = String.split(head, "", parts: 2, trim: true)

    with {:ok, type} <- valid_type?(type),
         {:ok, decimal} <- valid_decimal?(decimal) do
      {:ok, %{type: type, decimal: decimal}}
    else
      err -> err
    end
  end

  defp valid_type?(star_type)
       when star_type in @star_types,
       do: {:ok, star_type}

  defp valid_type?(_type), do: {:error, :invalid_type}

  defp valid_decimal?([decimal]) when decimal in @decimals, do: {:ok, decimal}

  defp valid_decimal?(_decimal),
    do: {:error, :invalid_decimal}

  defp valid_size?(_tail, %{size: "D"} = star), do: {:ok, star}
  defp valid_size?(_tail, %{type: "BD"} = star), do: {:ok, star}

  defp valid_size?(["IV"], %{type: "M"}),
    do: {:error, :invalid_size}

  defp valid_size?(["IV"], %{type: "K", decimal: dec})
       when dec in ["5", "6", "7", "8", "9"],
       do: {:error, :invalid_size}

  defp valid_size?(["VI"], %{type: "F", decimal: dec})
       when dec in ["0", "1", "2", "3", "4"],
       do: {:error, :invalid_size}

  defp valid_size?([size], %{type: type} = parts)
       when type in ["O", "B", "A"] and size in @star_sizes and size != "VI",
       do: {:ok, Map.put(parts, :size, size)}

  defp valid_size?([size], %{type: type} = parts)
       when type in ["F", "G", "K", "M"] and size in @star_sizes and
              size not in ["Ia", "Ib"],
       do: {:ok, Map.put(parts, :size, size)}

  defp valid_size?([_tail], _star),
    do: {:error, :invalid_size}

  defp validate_companion_type(companion, primary) do
    case valid_companion_type?(companion, primary) do
      true ->
        {:ok, companion}

      _ ->
        {:error, :incompatible_companion}
    end
  end

  defp valid_companion_type?(%{type: comp_type}, %__MODULE__{
         type: primary_type
       }),
       do: comp_type in primary_companion_types(primary_type)

  defp validate_companion_size(%{type: "BD"} = companion, _primary),
    do: {:ok, companion}

  defp validate_companion_size(companion, primary) do
    case valid_companion_size?(companion, primary) do
      true ->
        {:ok, companion}

      _ ->
        {:error, :incompatible_companion}
    end
  end

  defp valid_companion_size?(%{size: comp_size}, %__MODULE__{
         type: primary_type
       }),
       do: comp_size in primary_companion_sizes(primary_type)

  defp primary_companion_types(primary) when primary in ["O", "B"],
    do: ["O", "B", "A", "F", "G"]

  defp primary_companion_types("A"), do: ["A", "F", "G", "K"]

  defp primary_companion_types("F"), do: ["F", "M", "G", "K"]
  defp primary_companion_types("G"), do: ["G", "K", "M"]
  defp primary_companion_types("K"), do: ["K", "M", "BD"]
  defp primary_companion_types("M"), do: ["M", "BD"]

  defp primary_companion_sizes(primary) when primary in ["O", "B"],
    do: ["II", "III", "V"]

  defp primary_companion_sizes("A"),
    do: ["III", "IV", "V"]

  defp primary_companion_sizes(primary) when primary in ["F", "G", "K", "M"],
    do: ["V", "VI", "D"]
end
