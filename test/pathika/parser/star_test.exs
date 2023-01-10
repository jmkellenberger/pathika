defmodule Pathika.Parser.StarTest do
  use ExUnit.Case, async: true
  doctest Pathika.Parser.Star
  alias Pathika.Parser.Star

  describe "new/1" do
    test "Parses stellar data into star structs" do
      valid = "F7 V DM M3 V"

      assert Star.new(valid) ==
               {:ok,
                [
                  %Star{type: "F", size: "V", decimal: "7"},
                  %Star{type: "M", size: "D", decimal: ""},
                  %Star{type: "M", size: "V", decimal: "3"}
                ]}
    end

    test "Companion stars must be smaller than primary star" do
      invalid_companion = "DM F7 V M3 V"

      assert Star.new(invalid_companion) ==
               {:error, :incompatible_companion}
    end

    test "Stellar data must contain at least one star" do
      assert Star.new("     ") == {:error, :empty_input}
    end

    test "Stellar data must contain at most eight stars" do
      assert Star.new("F7 V DM M3 V DM DM DM DM DM DM") ==
               {:error, :exceeds_max_stars}
    end

    test "Types O, B, and A cannot be size VI" do
      for type <- ["O", "B", "A"], decimal <- 0..9 do
        assert Star.new("#{type}#{decimal} VI") ==
                 {:error, :invalid_size}
      end
    end

    test "F0-4 stars cannot be size VI" do
      for decimal <- 0..4 do
        assert Star.new("F#{decimal} VI") ==
                 {:error, :invalid_size}
      end
    end

    test "Types F, G, K, and M cannot be size Ia" do
      for type <- ["F", "G", "K", "M"], decimal <- 0..9 do
        assert Star.new("#{type}#{decimal} Ia") ==
                 {:error, :invalid_size}
      end
    end

    test "Types F, G, K, and M cannot be size Ib" do
      for type <- ["F", "G", "K", "M"], decimal <- 0..9 do
        assert Star.new("#{type}#{decimal} Ib") ==
                 {:error, :invalid_size}
      end
    end

    test "K5-9 stars cannot be size IV" do
      for decimal <- 5..9 do
        assert Star.new("K#{decimal} IV") ==
                 {:error, :invalid_size}
      end
    end

    test "M stars cannot be size IV" do
      for decimal <- 0..9 do
        assert Star.new("M#{decimal} IV") ==
                 {:error, :invalid_size}
      end
    end

    test "Dwarf stars ignore spectral decimal" do
      for type <- ["O", "B", "A", "F", "G", "K", "M"] do
        {:ok, [%{size: size, decimal: decimal, type: spectral}]} = Star.new("D#{type}")

        assert {size, decimal, spectral} == {"D", "", type}
      end
    end

    test "Brown Dwarf stars are invalid primary stars" do
      invalid_bd = "BD F7 V DM M3 V"

      assert Star.new(invalid_bd) ==
               {:error, :invalid_primary_type}
    end

    test "Brown dwarf stars ignore spectral decimal and size" do
      assert Star.new("M3 V BD") ==
               {:ok,
                [
                  %Star{type: "M", decimal: "3", size: "V"},
                  %Star{type: "BD", size: "", decimal: ""}
                ]}
    end

    test "Brown Dwarf stars valid companions for K and M type primaries." do
      for type <- ["K", "M"] do
        assert Star.new("#{type}3 V BD") ==
                 {:ok,
                  [
                    %Star{type: "#{type}", decimal: "3", size: "V"},
                    %Star{type: "BD", size: "", decimal: ""}
                  ]}
      end
    end

    test "Brown Dwarf stars invalid companions for O, B, A, F, and G type primaries." do
      for type <- ["O", "B", "A", "F", "G"] do
        assert Star.new("#{type}3 V BD") ==
                 {:error, :incompatible_companion}
      end
    end
  end
end
