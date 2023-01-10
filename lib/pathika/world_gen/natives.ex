defmodule Pathika.WorldGen.Natives do
  def check_for_natives(world) when world.uwp.government == 1 do
    {true, "Corporate Employees", "Locals are employees from elsewhere"}
  end

  def check_for_natives(world) when world.uwp.government == 6 do
    {true, "Colonists", "Locals are colonists from another world"}
  end

  def check_for_natives(world)
      when world.uwp.population == 0 and world.uwp.tech == 0 and
             world.uwp.atmosphere in [2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15] do
    {true, "Extinct Natives", "Intelligent Life evolved here but is now extinct"}
  end

  def check_for_natives(world)
      when world.uwp.population == 0 and world.uwp.tech == 0 and
             world.uwp.atmosphere in [10, 11, 12] do
    {true, "Extinct Exotic Natives", "Intelligent Life evolved here but is now extinct"}
  end

  def check_for_natives(world)
      when world.uwp.population == 0 and world.uwp.tech > 0 and
             world.uwp.atmosphere in [2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15] do
    {true, "Catastrophic XN", "Evidence of Exinct Natives remains"}
  end

  def check_for_natives(world)
      when world.uwp.population == 0 and world.uwp.tech > 0 and
             world.uwp.atmosphere in [10, 11, 12] do
    {true, "Catastrophic EXN", "Evidence of Exotic Extinct Natives remains"}
  end

  def check_for_natives(world)
      when world.uwp.population == [1, 2, 3] and world.uwp.tech > 0 do
    {false, "Transients", "Temporary commercial or scientific activity"}
  end

  def check_for_natives(world)
      when world.uwp.population == [4, 5, 6] and world.uwp.tech > 0 do
    {false, "Settlers", "The initial steps of creating a colony"}
  end

  def check_for_natives(world)
      when world.uwp.population > 6 and world.uwp.tech > 0 and world.uwp.atmosphere < 2 do
    {false, "Transplants", "Current locals evolved elsewhere"}
  end

  def check_for_natives(world)
      when world.uwp.population == 0 and world.uwp.tech > 0 and world.uwp.atmosphere < 2 do
    {false, "Vanished Transplants", "Evidence of Transplants, no longer present"}
  end

  def check_for_natives(world)
      when world.uwp.population > 6 and world.uwp.tech > 0 and
             world.uwp.atmosphere in [10, 11, 12] do
    {true, "Exotic Natives", "Environment incompatible with humans"}
  end

  def check_for_natives(world)
      when world.uwp.population > 6 and world.uwp.tech > 0 and
             world.uwp.atmosphere in [2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15] do
    {true, "Natives", "Intelligent Life evolved on this world"}
  end

  def check_for_natives(_), do: {false, "N/A", "Intelligent life has not evolved on this world"}
end
