defmodule Pathika.System do
  @moduledoc """
  Parses Traveller5 Second Survey data into system structs. See https://travellermap.com/doc/fileformats.any()

    iex> Pathika.System.parse_data(
          "
          Name                                   Hex  UWP       Remarks                                  {Ix}   (Ex)    [Cx]   N     B  Z PBG W  A    Stellar \
          -------------------------------------- ---- --------- ---------------------------------------- ------ ------- ------ ----- -- - --- -- ---- -------------- \
          Zeycude                                0101 C430698-9 De Na Ni Po                              { -1 } (C53-1) [6559] -     -  - 613 8  ZhIN K9 V
          "
        )

        [
        %Pathika.System{
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

  @t5_header_to_keys %{
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
  @header_t5 "Hex  Name                 UWP       Remarks                                  {Ix}   (Ex)    [Cx]   N     B  Z PBG W  A    Stellar"
  @separator_t5 "---- -------------------- --------- ---------------------------------------- ------ ------- ------ ----- -- - --- -- ---- --------------"

  def sample do
    """
    Name                                   Hex  UWP       Remarks                                  {Ix}   (Ex)    [Cx]   N     B  Z PBG W  A    Stellar
    -------------------------------------- ---- --------- ---------------------------------------- ------ ------- ------ ----- -- - --- -- ---- --------------
    Zeycude                                0101 C430698-9 De Na Ni Po                              { -1 } (C53-1) [6559] -     -  - 613 8  ZhIN K9 V
    Reno                                   0102 C4207B9-A De He Na Po Pi Pz                        { 1 }  (C6A+2) [886B] -     -  A 603 12 ZhIN G8 V M1 V
    Errere                                 0103 B563664-B Ni Ri O:0304                             { 3 }  (957+1) [4939] -     KM - 910 9  ZhIN M1 V M4 V
    Cantrel                                0104 C566243-9 Lo                                       { -1 } (610-4) [1126] -     -  - 520 12 ZhIN F1 V
    Gyomar                                 0108 C8B2889-8 Fl He Ph (Tethmari)                      { -1 } (G77+1) [9769] -     -  - 824 14 NaHu A8 V
    Thengo                                 0202 C868586-5 Ag Ni Pr                                 { -1 } (743-2) [4444] -     -  - 801 12 ZhIN G5 V M3 V
    Rio                                    0301 C686648-8 Ag Ni Ga Ri                              { 0 }  (954+1) [6658] -     -  - 201 8  NaHu M0 V M1 V
    GesentownGesentownGesentown            0303 B31169B-C Ic Na Ni Da                              { 2 }  (956+4) [887E] -     KM A 801 12 ZhIN M2 V M9 V
    Chronor                                0304 A6369A5-D Hi Cp                                    { 4 }  (C8G+2) [7D3B] -     KM - 810 5  ZhIN F8 V
    Atsa                                   0307 B4337CA-A Na Po An Pz
    """
  end

  def parse_data(data) do
    {key, data} =
      data
      |> String.split("\n", trim: true)
      |> parse_headers()

    data |> Enum.map(&build_system(&1, key))
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

  @spec build_system(any, map) :: any
  def build_system(data, fields) do
    Map.keys(fields)
    |> Enum.reduce(%__MODULE__{}, fn key, system -> put_attribute(key, system, data, fields) end)
  end

  defp put_attribute(key, system, data, fields) do
    value = String.slice(data, fields[key]) |> String.trim()
    Map.put(system, @t5_header_to_keys[key], value)
  end
end
