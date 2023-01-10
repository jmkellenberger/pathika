defmodule Pathika.Parser do
  alias Pathika.Parser.{Star, UWP}

  defdelegate parse_uwp(input, type), to: UWP, as: :new
  defdelegate parse_stars(input), to: Star, as: :new
end
