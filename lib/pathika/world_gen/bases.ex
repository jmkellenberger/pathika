defmodule Pathika.WorldGen.Bases do
  alias Pathika.Math

  def check_bases(world) do
    world
    |> Map.put(:bases, %{scout: false, naval: false})
    |> check_scout(Math.roll(2))
    |> check_naval(Math.roll(2))
  end

  defp check_scout(world, roll) when world.port == :A and roll <= 4 do
    %{world | bases: Map.put(world.bases, :scout, true)}
  end

  defp check_scout(world, roll) when world.port == :B and roll <= 5 do
    %{world | bases: Map.put(world.bases, :scout, true)}
  end

  defp check_scout(world, roll) when world.port == :C and roll <= 6 do
    %{world | bases: Map.put(world.bases, :scout, true)}
  end

  defp check_scout(world, roll) when world.port == :D and roll <= 7 do
    %{world | bases: Map.put(world.bases, :scout, true)}
  end

  defp check_scout(world, _roll), do: world

  defp check_naval(world, roll) when world.port == :A and roll <= 6 do
    %{world | bases: Map.put(world.bases, :naval, true)}
  end

  defp check_naval(world, roll) when world.port == :B and roll <= 5 do
    %{world | bases: Map.put(world.bases, :naval, true)}
  end

  defp check_naval(world, _roll), do: world
end
