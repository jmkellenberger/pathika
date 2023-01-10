defmodule Pathika.EhexTest do
  use ExUnit.Case, async: true
  doctest Pathika.Ehex
  alias Pathika.Ehex

  describe "to_ehex/1" do
    test "converts a given integer to it's corresponding eHex value" do
      values = Enum.reduce(33..0, [], fn n, acc -> [Ehex.to_ehex(n) | acc] end)

      ehex = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "J",
        "K",
        "L",
        "M",
        "N",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z"
      ]

      assert ehex == values
    end

    test "Invalid values are returned as question marks" do
      assert "?" == Ehex.to_ehex(99)
    end
  end

  describe "from_ehex/1" do
    test "converts an eHex character to it's corresponding integer value" do
      values = Enum.to_list(33..0)

      ehex =
        [
          "0",
          "1",
          "2",
          "3",
          "4",
          "5",
          "6",
          "7",
          "8",
          "9",
          "A",
          "B",
          "C",
          "D",
          "E",
          "F",
          "G",
          "H",
          "J",
          "K",
          "L",
          "M",
          "N",
          "P",
          "Q",
          "R",
          "S",
          "T",
          "U",
          "V",
          "W",
          "X",
          "Y",
          "Z"
        ]
        |> Enum.reduce([], fn n, acc -> [Ehex.from_ehex(n) | acc] end)

      assert ehex == values
    end

    test "Invalid values are returned as :unknown atoms" do
      assert :unknown == Ehex.from_ehex("?")
    end
  end
end
