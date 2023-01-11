defmodule Pathika.Parser.System do
  alias Pathika.WorldGen
  @moduledoc """
  Parses Traveller5 Second Survey data into system structs. See https://travellermap.com/doc/fileformats.any()

    iex> Pathika.Parser.System.parse_data(
          "
          Name                                   Hex  UWP       Remarks                                  {Ix}   (Ex)    [Cx]   N     B  Z PBG W  A    Stellar \
          -------------------------------------- ---- --------- ---------------------------------------- ------ ------- ------ ----- -- - --- -- ---- -------------- \
          Zeycude                                0101 C430698-9 De Na Ni Po                              { -1 } (C53-1) [6559] -     -  - 613 8  ZhIN K9 V
          "
        )

        [
        %Pathika.Parser.System{
          hex: "0101",
          name: "Zeycude",
          uwp: "C430698-9",
          remarks: "De Na Ni Po",
          importance: "{ -1 }",
          economy: "(C53-1)",
          culture: "[6559]",
          nobility: "-",
          bases: "-",
          travel_zone: "-",
          pbg: "613",
          worlds: "8",
          allegiance: "ZhIN",
          stellar: "K9 V"
        }
      ]
  """

  defstruct [
    :hex,
    :name,
    :uwp,
    :remarks,
    :importance,
    :economy,
    :culture,
    :nobility,
    :bases,
    :travel_zone,
    :pbg,
    :worlds,
    :allegiance,
    :stellar
  ]

  @t5_fields_to_keys %{
    "hex" => :hex,
    "name" => :name,
    "uwp" => :uwp,
    "remarks" => :remarks,
    "{ix}" => :importance,
    "(ex)" => :economy,
    "[cx]" => :culture,
    "n" => :nobility,
    "b" => :bases,
    "z" => :travel_zone,
    "pbg" => :pbg,
    "w" => :worlds,
    "a" => :allegiance,
    "stellar" => :stellar
  }

  @doc """
  Sample System Data
  """
  def sample do
    """
    Hex  Name                 UWP       Remarks                                  {Ix}   (Ex)    [Cx]   N     B  Z PBG W  A    Stellar
    ---- -------------------- --------- ---------------------------------------- ------ ------- ------ ----- -- - --- -- ---- --------------
    0101 Zeycude              C430698-9 De Na Ni Po                              { -1 } (C53-1) [6559] -     -  - 613 8  ZhIN K9 V
    0102 Reno                 C4207B9-A De He Na Po Pi Pz                        { 1 }  (C6A+2) [886B] -     -  A 603 12 ZhIN G8 V M1 V
    0103 Errere               B563664-B Ni Ri O:0304                             { 3 }  (957+1) [4939] -     KM - 910 9  ZhIN M1 V M4 V
    0104 Cantrel              C566243-9 Lo                                       { -1 } (610-4) [1126] -     -  - 520 12 ZhIN F1 V
    0108 Gyomar               C8B2889-8 Fl He Ph (Tethmari)                      { -1 } (G77+1) [9769] -     -  - 824 14 NaHu A8 V
    0202 Thengo               C868586-5 Ag Ni Pr                                 { -1 } (743-2) [4444] -     -  - 801 12 ZhIN G5 V M3 V
    0301 Rio                  C686648-8 Ag Ni Ga Ri                              { 0 }  (954+1) [6658] -     -  - 201 8  NaHu M0 V M1 V
    0303 Gesentown            B31169B-C Ic Na Ni Da                              { 2 }  (956+4) [887E] -     KM A 801 12 ZhIN M2 V M9 V
    0304 Chronor              A6369A5-D Hi Cp                                    { 4 }  (C8G+2) [7D3B] -     KM - 810 5  ZhIN F8 V
    0307 Atsa                 B4337CA-A Na Po An Pz                              { 3 }  (A6C+5) [9A7C] -     KM A 810 8  ZhIN F7 V M3 V
    0503 Whenge               D648500-8 Ag Ni                                    { -2 } (842-5) [1313] -     -  - 610 13 NaHu F8 V
    0601 Enlas-du             E975776-6 Ag Pi                                    { -1 } (966-2) [6645] -     -  - 323 14 NaHu F1 V
    0605 Algebaster           C665658-9 Ag Ni Ga Ri                              { 1 }  (955+1) [6759] -     -  - 410 10 NaHu M0 V M1 V
    0607 Rasatt               E883401-7 Ni                                       { -3 } (631-5) [1113] -     -  - 910 6  NaHu F0 V
    0608 Ninjar               A311666-C Ic Na Ni Mr                              { 2 }  (956+1) [584B] -     KM - 410 6  ZhIN A4 V
    0610 Sheyou               B756779-A Ag Ga                                    { 4 }  (B6D+5) [8B6B] -     KM - 111 13 ZhIN F4 V M0 V
    0703 Indo                 E434662-6 Ni O:0605                                { -3 } (851-5) [2312] -     -  - 320 11 NaHu F6 V
    0704 Nerewhon             E738475-7 Ni                                       { -3 } (631-5) [2135] -     -  - 820 10 NaHu K5 V
    0705 Cipango              A886865-C Ga Ri Pa Ph O:0304                       { 4 }  (D7E+2) [6C3A] -     KM - 121 10 ZhIN G2 V
    0710 Stave                E7667A8-2 Ag Ga Ri (Obeyery)                       { 0 }  (965+1) [7752] -     -  - 801 8  NaHu K9 V M2 V
    0805 Narval               D525688-7 Ni Da                                    { -3 } (851-3) [6357] -     M  A 603 10 CsZh G4 V M6 V
    0807 Plaven               E845300-5 Lo                                       { -3 } (520-5) [1111] -     -  - 910 6  NaHu G8 V M7 V
    0808 Quar                 B532720-B Na Po Pz                                 { 2 }  (A6C-2) [2916] -     N  A 401 9  CsIm M2 V
    0810 Frond                E9C3300-9 Fl Lo                                    { -2 } (820-5) [1114] -     -  - 103 12 CsIm F8 V
    """
  end

  def parse_data(data) do
    {key, data} =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> parse_headers()

    Enum.map(data, &build_system(&1, key))
              |> Enum.reduce_while(%{}, fn system, acc ->
                case input_to_world(system) do
                  {:ok, system} -> {:cont, Map.put(acc, system.hex, system)}
                  error -> {:halt, error}
                end
              end)
  end

  defp parse_headers([header, separator | data]) do
    fields = String.split(header, " ", trim: true) |> Enum.map(&String.downcase/1)
    positions = String.split(separator, " ", trim: true) |> field_positions([])
    key = Enum.zip(fields, positions) |> Enum.into(%{})
    {key, data}
  end

  defp field_positions(separators, positions, start_pos \\ 0)
  defp field_positions([], positions, _start_pos), do: Enum.reverse(positions)

  defp field_positions([field | separators], positions, start_pos) do
    length = field |> String.length()
    max = start_pos + length - 1
    postions = [start_pos..max | positions]
    field_positions(separators, postions, max + 2)
  end

  defp build_system(data, fields) do
    Map.keys(fields)
    |> Enum.reduce(%__MODULE__{}, fn key, system -> put_attribute(key, system, data, fields) end)
  end

  defp put_attribute(key, system, data, fields) do
    value = String.slice(data, fields[key]) |> String.trim()
    Map.put(system, @t5_fields_to_keys[key], value)
  end

  defp input_to_world(system) do
    case  Pathika.Parser.UWP.new(system.uwp) do
      {:ok, uwp} -> attrs =
                  Map.from_struct(uwp)
                  |> Map.put(:hex, system.hex)
                  |> Map.put(:name, system.name)
                  |> Map.put(:bases, get_bases(system))
                  |> Map.put(:travel_zone, get_zone(system))
                  |> Map.merge(get_pbg(system))
                  |> Keyword.new(fn {k, v} -> {k, v} end)

                  {:ok, WorldGen.build(:main, attrs)}
        err -> {:error, err}
    end
  end

  defp get_bases(system) do
    bases = system.bases |> to_charlist()
    %{naval: Enum.member?(bases, "N"), scout: Enum.member?(bases, "S")}
  end

  defp get_zone(system) do
    case system.travel_zone do
      "R" -> :red
      "A" -> :amber
      _ -> :green
    end
  end

  defp get_pbg(%{pbg: pbg}) when byte_size(pbg) === 3 do
    [p, b, g] = String.split(pbg, "", trim: true) |> Enum.map(&String.to_integer/1)
    %{population_digit: p, belts: b, gas_giants: g}
  end

  defp get_pbg(_system) do
    %{population_digit: 1, belts: 0, gas_giants: 0}
  end
end
