defmodule Pathika.WorldGen.Bases do
  alias Pathika.WorldGen.World
  alias Pathika.Math

  def check_bases(world) do
    world
    |> check_scout(Math.roll(2))
    |> check_naval(Math.roll(2))
  end

  defp check_scout(world, roll) when world.uwp.starport == "A" and roll <= 4 do
    bases = %{world.bases | scout: true}

    %World{world | bases: bases}
  end

  defp check_scout(world, roll) when world.uwp.starport == "B" and roll <= 5 do
    bases = %{world.bases | scout: true}

    %World{world | bases: bases}
  end

  defp check_scout(world, roll) when world.uwp.starport == "C" and roll <= 6 do
    bases = %{world.bases | scout: true}

    %World{world | bases: bases}
  end

  defp check_scout(world, roll) when world.uwp.starport == "D" and roll <= 7 do
    bases = %{world.bases | scout: true}

    %World{world | bases: bases}
  end

  defp check_scout(world, _roll), do: %{world | bases: %{scout: false}}

  defp check_naval(world, roll) when world.uwp.starport == "A" and roll <= 6 do
    bases = %{world.bases | naval: true}

    %World{world | bases: bases}
  end

  defp check_naval(world, roll) when world.uwp.starport == "B" and roll <= 5 do
    bases = %{world.bases | naval: true}

    %World{world | bases: bases}
  end

  defp check_naval(world, _roll), do: %{world | bases: Map.put(world.bases, :naval, false)}
end
