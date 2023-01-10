defmodule Pathika.Parser.UWPTest do
  use ExUnit.Case, async: true
  doctest Pathika.Parser.UWP

  alias Pathika.Parser.UWP

  describe "when generating a main world" do
    test "creates a main world from a valid UWP" do
      world = "A788899-C"

      assert UWP.new(world, :main) ==
               {:ok,
                %UWP{
                  port: :a,
                  size: 7,
                  atmosphere: 8,
                  hydrographics: 8,
                  population: 8,
                  government: 9,
                  law: 9,
                  tech: 12
                }}
    end

    test "Creates a world with placeholder values from ???????-?" do
      assert UWP.new("???????-?") ==
               {:ok,
                %UWP{
                  port: :unknown,
                  size: :unknown,
                  atmosphere: :unknown,
                  hydrographics: :unknown,
                  population: :unknown,
                  government: :unknown,
                  law: :unknown,
                  tech: :unknown
                }}
    end

    test "creates a world with ? in place of some values" do
      assert UWP.new("A?9A?5?-?") ==
               {:ok,
                %UWP{
                  port: :a,
                  size: :unknown,
                  atmosphere: 9,
                  hydrographics: 10,
                  population: :unknown,
                  government: 5,
                  law: :unknown,
                  tech: :unknown
                }}
    end

    test "Constrains values to expected ranges based on given values " do
      assert UWP.new("A2?A?5?-?") ==
               {:error, :invalid_hydrographics}

      assert UWP.new("A??A0?5-?") ==
               {:error, :invalid_law_level}
    end

    test "returns an error when creating an alternate world with a starport" do
      world = "A788899-C"

      assert UWP.new(world, :hospitable) ==
               {:error, :invalid_port}
    end

    test "returns an error when size is invalid" do
      world = "AG88899-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_size}
    end

    test "returns an error when atmosphere is invalid" do
      world = "A8Z8899-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_atmosphere}
    end

    test "returns an error when hydrographics is invalid" do
      world = "A880899-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_hydrographics}
    end

    test "returns an error when population is invalid" do
      world = "A883G99-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_population}
    end

    test "returns an error when government is invalid" do
      world = "A8835B9-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_government}
    end

    test "returns an error when law is invalid" do
      world = "A883519-C"

      assert UWP.new(world, :main) ==
               {:error, :invalid_law_level}
    end

    test "returns an error when tech is invalid" do
      world = "A000559-6"

      assert UWP.new(world, :main) ==
               {:error, :invalid_tech_level}
    end
  end

  describe "When creating an InfernoWorld (YSB0000-0) where size is 1d6+6" do
    test "returns a world when given valid UWP" do
      world1 = "Y7B0000-0"

      assert UWP.new(world1, :inferno) ==
               {:ok,
                %UWP{
                  port: :y,
                  size: 7,
                  atmosphere: 11,
                  hydrographics: 0,
                  population: 0,
                  government: 0,
                  law: 0,
                  tech: 0
                }}

      world2 = "YCB0000-0"

      assert UWP.new(world2, :inferno) ==
               {:ok,
                %UWP{
                  port: :y,
                  size: 12,
                  atmosphere: 11,
                  hydrographics: 0,
                  population: 0,
                  government: 0,
                  law: 0,
                  tech: 0
                }}
    end

    test "returns an error when given invalid values" do
      world1 = "Y7BA568-C"

      assert UWP.new(world1, :inferno) ==
               {:error, :invalid_hydrographics}

      world2 = "FCB0000-0"

      assert UWP.new(world2, :inferno) ==
               {:error, :invalid_port}

      world3 = "Y7A0000-0"

      assert UWP.new(world3, :inferno) ==
               {:error, :invalid_atmosphere}
    end
  end

  describe "When creating a RadWorld (StSAH000-0) where size is 2D" do
    test "returns a world when given valid UWP" do
      world1 = "Y465000-0"

      assert UWP.new(world1, :rad) ==
               {:ok,
                %UWP{
                  port: :y,
                  size: 4,
                  atmosphere: 6,
                  hydrographics: 5,
                  population: 0,
                  government: 0,
                  law: 0,
                  tech: 0
                }}

      world2 = "YCFA000-0"

      assert UWP.new(world2, :rad) ==
               {:ok,
                %UWP{
                  port: :y,
                  size: 12,
                  atmosphere: 15,
                  hydrographics: 10,
                  population: 0,
                  government: 0,
                  law: 0,
                  tech: 0
                }}
    end

    test "returns an error when given invalid values" do
      world1 = "Y465355-6"

      assert UWP.new(world1, :rad) ==
               {:error, :invalid_population}

      world2 = "FCFA000-0"

      assert UWP.new(world2, :rad) ==
               {:error, :invalid_port}

      world3 = "Y100000-0"

      assert UWP.new(world3, :rad) ==
               {:error, :invalid_size}
    end
  end

  describe "When creating a hospitable world (as Main, but port F-Y)" do
    test "returns a world when given valid UWP" do
      world1 = "Y465355-6"

      assert UWP.new(world1, :hospitable) ==
               {:ok,
                %UWP{
                  atmosphere: 6,
                  government: 5,
                  hydrographics: 5,
                  law: 5,
                  population: 3,
                  port: :y,
                  size: 4,
                  tech: 6
                }}

      world2 = "FCFA9EG-C"

      assert UWP.new(world2, :hospitable) ==
               {:ok,
                %UWP{
                  atmosphere: 15,
                  government: 14,
                  hydrographics: 10,
                  law: 16,
                  population: 9,
                  port: :f,
                  size: 12,
                  tech: 12
                }}
    end

    test "returns an error when given a mainworld port" do
      world = "A788899-C"

      assert UWP.new(world, :hospitable) ==
               {:error, :invalid_port}
    end

    test "returns an error when given a invalid combination of values" do
      world = "F788099-C"

      assert UWP.new(world, :hospitable) ==
               {:error, :invalid_port}

      world = "Y788099-C"

      assert UWP.new(world, :hospitable) ==
               {:error, :invalid_government}
    end
  end

  describe "When creating a planetoid (St000PGL-T) belt" do
    test "returns a world when given valid UWP" do
      world1 = "H000355-6"

      assert UWP.new(world1, :planetoid) ==
               {:ok,
                %UWP{
                  atmosphere: 0,
                  government: 5,
                  hydrographics: 0,
                  law: 5,
                  population: 3,
                  port: :h,
                  size: 0,
                  tech: 6
                }}

      world2 = "Y0009EG-B"

      assert UWP.new(world2, :planetoid) ==
               {:ok,
                %UWP{
                  atmosphere: 0,
                  government: 14,
                  hydrographics: 0,
                  law: 16,
                  population: 9,
                  port: :y,
                  size: 0,
                  tech: 11
                }}
    end

    test "returns an error when given invalid values" do
      assert UWP.new("H100355-6", :planetoid) ==
               {:error, :invalid_size}

      assert UWP.new("H020355-6", :planetoid) ==
               {:error, :invalid_atmosphere}

      assert UWP.new("Y0039EG-B", :planetoid) ==
               {:error, :invalid_hydrographics}

      assert UWP.new("E0039EG-B", :planetoid) ==
               {:error, :invalid_port}
    end
  end

  describe "When creating a Worldlet (as Hospitable, but size 1D-3)" do
    test "Returns a world with valid values" do
      assert UWP.new("H100355-6", :worldlet) ==
               {:ok,
                %UWP{
                  port: :h,
                  size: 1,
                  atmosphere: 0,
                  hydrographics: 0,
                  population: 3,
                  government: 5,
                  law: 5,
                  tech: 6
                }}

      assert UWP.new("H200355-6", :worldlet) ==
               {:ok,
                %UWP{
                  port: :h,
                  size: 2,
                  atmosphere: 0,
                  hydrographics: 0,
                  population: 3,
                  government: 5,
                  law: 5,
                  tech: 6
                }}

      assert UWP.new("H311355-6", :worldlet) ==
               {:ok,
                %UWP{
                  port: :h,
                  size: 3,
                  atmosphere: 1,
                  hydrographics: 1,
                  population: 3,
                  government: 5,
                  law: 5,
                  tech: 6
                }}
    end

    test "returns an error when given invalid size" do
      assert UWP.new("H411355-6", :worldlet) ==
               {:error, :invalid_size}
    end
  end

  describe "When creating an IceWorld (as Hospitable, but Pop - 6)" do
    test "Returns a world with valid values" do
      assert UWP.new("H100355-6", :ice) ==
               {:ok,
                %UWP{
                  port: :h,
                  size: 1,
                  atmosphere: 0,
                  hydrographics: 0,
                  population: 3,
                  government: 5,
                  law: 5,
                  tech: 6
                }}
    end

    test "Returns an error with invalid values" do
      assert UWP.new("H100655-6", :ice) ==
               {:error, :invalid_population}
    end
  end

  describe "When creating an InnerWorld (as Hospitable, but Pop & Hyd -4 )" do
    test "Returns a world with valid values" do
      assert UWP.new("H566355-6", :inner) ==
               {:ok,
                %UWP{
                  atmosphere: 6,
                  government: 5,
                  hydrographics: 6,
                  law: 5,
                  population: 3,
                  port: :h,
                  size: 5,
                  tech: 6
                }}
    end

    test "Returns an error with invalid values" do
      assert UWP.new("H56A955-6", :inner) ==
               {:error, :invalid_hydrographics}

      assert UWP.new("H566955-6", :inner) ==
               {:error, :invalid_population}
    end
  end

  describe "When creating a StormWorld (Siz 2D, Atm +4, Hyd & Pop -6 )" do
    test "Returns a world with valid values" do
      assert UWP.new("YAD6455-6", :storm) ==
               {:ok,
                %UWP{
                  atmosphere: 13,
                  government: 5,
                  hydrographics: 6,
                  law: 5,
                  population: 4,
                  port: :y,
                  size: 10,
                  tech: 6
                }}
    end

    test "Returns an error with invalid values" do
      assert UWP.new("H56A955-6", :storm) ==
               {:error, :invalid_hydrographics}

      assert UWP.new("HC67955-6", :storm) ==
               {:error, :invalid_atmosphere}
    end
  end

  describe "When creating a BigWorld (Siz 2D+7)" do
    test "Returns a world with valid values" do
      assert UWP.new("YFDA455-6", :big) ==
               {:ok,
                %UWP{
                  atmosphere: 13,
                  government: 5,
                  hydrographics: 10,
                  law: 5,
                  population: 4,
                  port: :y,
                  size: 15,
                  tech: 6
                }}
    end

    test "Returns an error with invalid values" do
      assert UWP.new("H56A955-6", :big) ==
               {:error, :invalid_size}

      assert UWP.new("HC60955-6", :big) ==
               {:error, :invalid_atmosphere}
    end
  end
end
