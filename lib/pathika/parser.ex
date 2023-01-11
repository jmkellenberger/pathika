defmodule Pathika.Parser do
  alias Pathika.Parser.{Star, UWP, System}

  defdelegate parse_system_data(input), to: System, as: :parse_data

  defdelegate parse_uwp(input, type), to: UWP, as: :new
  defdelegate parse_stars(input), to: Star, as: :new
end
