defmodule Pathika.WorldGen.Descriptions do
  alias Pathika.Formatter

  @data %{
    port: %{
      "X" =>
        "No starport. Class X starports are generally indicative of an interdiction. No provision is made for any starship landings and such landings are probably prohibited.",
      "E" =>
        "Frontier installation. Essentially a bare spot of bedrock with no fuel, facilities, or bases present.",
      "D" =>
        "Poor quality installation. Only unrefined fuel available. No repair or shipyard facilities present.",
      "C" =>
        "Routine quality installation. Only unrefined fuel available. Reasonable repair facilities are present.",
      "B" =>
        "Good quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of constructing non-starships present.",
      "A" =>
        "Excellent quality installation. Refined fuel available. Annual maintenance overhaul available. Shipyard capable of both starship and non-starship construction present."
    },
    size: %{
      0 => "Asteroid/Planetary Belt. Diameter: < 200km. Microgravity (< 0.01G)",
      1 => "Small. Diameter: 	800-2399km. Very Low Gravity (0.02G - 0.03G)",
      2 => "Small (e.g. Luna). Diameter: 2,400-3,999km. Low Gravity (0.10g - 0.17g)",
      3 => "Small (e.g. Mercury). Diameter: 4,000-5,599km. Low Gravity (0.24g - 0.34g)",
      4 => "Medium (e.g. Mars). Diameter: 5,600-7,199. Low Gravity (0.32g - 0.46g)",
      5 => "Medium. Diameter: 7,200-8,799km. Standard Gravity (0.40g - 0.57g)",
      6 => "Medium. Diameter: 8,800-10,399km. Standard Gravity (0.60g - 0.81g)",
      7 => "Large. Diameter: 10,400-11,999km. Standard Gravity (0.70g - 0.94g)",
      8 =>
        "Large (e.g. Venus / Terra). Diameter: 12,000-13,599km. Standard Gravity (0.80g - 1.08g)",
      9 => "Large. Diameter: 13,600-15,199km. Standard Gravity (1.03g - 1.33g)",
      10 => "Huge. Diameter: 15,200-16,799km. Standard Gravity (1.14g - 1.48g)",
      11 => "Huge. Diameter: 16,800 - 18,399km. High Gravity (1.49g - 1.89g)",
      12 => "Huge. Diameter: 18,400 - 19,999km. High Gravity (1.9g - 2.0g)",
      13 => "Massive. Diameter: 20,000 - 21,599km. Macrogravity (2.01G+)",
      14 => "Massive. Diameter: 21,600 - 23,199km. Macrogravity (2.01G+)",
      15 => "Massive. Diameter: 23,200+. Macrogravity (2.01G+)"
    },
    atmosphere: %{
      0 => "Vacuum. Vacuum requires a vacc suit. ",
      1 =>
        "Trace. The atmosphere has a pressure of less than 0.1 atmospheres, which requires the use of a vacc suit.",
      2 => "Very Thin, Tainted. Requires: Filter/Respirator combination.",
      3 =>
        "Very Thin. The atmosphere has a pressure of 0.1 to 0.42 atmospheres, which requires the use of a respirator to ensure sufficient oxygen.",
      4 =>
        "Thin, Tainted. The atmosphere contains an unusual taint such as such as disease, a hazardous gas mix, pollutants, or sulfur compounds which requires the use of a filter mask.",
      5 =>
        "Thin.  No survival gear required. The atmosphere has a pressure of 0 43 to 0.70 atmospheres. The atmosphere is a standard oxygen/nitrogen mix, which is breathable without assistance.",
      6 =>
        "Standard.  No survival gear required. The atmosphere has a pressure of 0.71 to 1.49 atmospheres. The atmosphere is a standard oxygen/nitrogen mix, which is breathable without assistance. ",
      7 =>
        "Standard, Tainted.  The atmosphere contains an unusual taint such as such as disease, a hazardous gas mix, pollutants, or sulfur compounds which requires the use of a filter mask.",
      8 =>
        "Dense.  No survival gear required. The atmosphere has a pressure of 1.50 to 2.49 atmospheres The atmosphere is a standard oxygen/nitrogen mix, which is breathable without assistance.",
      9 =>
        "Dense, Tainted.  The atmosphere contains an unusual taint such as such as disease, a hazardous gas mix, pollutants, or sulfur compounds which requires the use of a filter mask.",
      10 =>
        "Exotic. An unusual gas mix which requires the use of oxygen tanks, but protective suits are not needed.",
      11 =>
        "Corrosive. A concentrated gas mix or unusual temperature creates a corrosive environment, which requires the use of a Hostile environment suit or vacc suit.",
      12 =>
        "Insidious. A concentrated gas mix or unusual temperature creates a corrosive environment, which requires the use of a Hostile environment suit or vacc suit. Extreme corrosive effects defeat protective measures within 2 - 12 hours.",
      13 =>
        "Dense, High. Typically no survival gear required under many conditions. Pressure at or below sea level is too great to support life, but breathable at higher altitudes.",
      14 =>
        "Thin, low. variloes	Typically no survival gear required under some conditions. This world is large and massive, with a thin atmosphere which settles to the lowest levels of the terrain. The atmosphere is un-breathable at most altitudes except the very low ones (…as in depressions or deep valleys).",
      15 =>
        "Unusual. An anomalous atmosphere, (e.g. an ellipsoidal world world with varing atmospheric pressure at the surface). Survival gear varies based on local conditions."
    },
    hydrographics: %{
      0 => "Desert World. < 10% surface water.",
      1 => "Dry World. 10-19% surface water.",
      2 => "Dry World 20-29% surface water.",
      3 => "Wet World 30-39% surface water.",
      4 => "Wet World 40-49% surface water.",
      5 => "Average Wet World 50-59% surface water.",
      6 => "Wet World 60-69% surface water.",
      7 => "Wet World 70-79% surface water.",
      8 => "Very Wet World 80-89% surface water.",
      9 => "Very Wet World 90-99% surface water.",
      10 => "Water World 100% surface water."
    },
    population: %{
      0 => "Unpopulated.",
      1 => "Tens",
      2 => "Hundreds",
      3 => "Thousands",
      4 => "Ten Thousands",
      5 => "Hundred Thousands",
      6 => "Millions",
      7 => "Ten Millions",
      8 => "Hundred Millions",
      9 => "Billions",
      10 => "Ten Billions",
      11 => "Hundred Billions",
      12 => "Trillions",
      13 => "Ten Trillions",
      14 => "Hundred Trillions",
      15 => "Quadrillions"
    },
    government: %{
      0 => "No Government Structure. In many cases tribal, clan or family bonds predominate.",
      1 =>
        "Company/Corporation. Government by a company managerial elite, citizens are company employees.",
      2 => "Participating Democracy. Government by advice and consent of the citizen.",
      3 =>
        "Self-perpetuating Oligarchy. Government by a restricted minority, with little or no input from the masses.",
      4 => "Representative Democracy. Government by elected representatives.",
      5 =>
        "Feudal Technocracy. Government by specific individuals for those who agree to be ruled. Relationships are based on the perfomance of technical activities which are mutually beneficial.",
      6 =>
        "Captive Government/Colony. Government by a leadership answerable to an outside group, a coony or conquered area.",
      7 =>
        "Balkanization. No central ruling authority exists. Several rival governments compete for control of the world.",
      8 =>
        "Civil Service Bureaucracy. Government by agencies employing individuals selected for their expertise.",
      9 =>
        "Impersonal Bureaucracy. Gvoernment by agencies which are insulated from the governed.",
      10 =>
        "Charismatic Dictator. Government by a single leader enjoying the confidence of the citizens.",
      11 =>
        "Non-Charismatic Leader. A previous charismatic dictator has been replaced by a leader through normal channels.",
      12 =>
        "Charismatic Oligarchy. Government by a select group, organization, or class enjoying overwhelming confidence of the citizenry.",
      13 =>
        "Religious Dictatorship. Government by a religious minority which has little regard for the needs of the citizenry.",
      14 =>
        "Religious Autocracy. Government by a single religious leader having absolute power over the citizenry.",
      15 =>
        "Totalitarian Oligarchy. Government by an all-powerful minority which maintains absolute control through widespread coercion and oppression."
    },
    law: %{
      0 => "No Law. No prohibitions.",
      1 =>
        "Low Law. Prohibited/controlled weapons(includes those of earlier codes): Body Pistols, Explosives, Nuclear Weapons, and Poison Gas.",
      2 =>
        "Low Law. Prohibited/controlled weapons(includes those of earlier codes): Portable Energy Weapons.",
      3 =>
        "Low Law. Prohibited/controlled weapons(includes those of earlier codes): Machine Guns, Automatic Weapons, Flamethrowers, military weapons.",
      4 =>
        "Moderate Law. Prohibited/controlled weapons(includes those of earlier codes): Light Assault Weapons, Submachine guns, All Energy weapons.",
      5 =>
        "Moderate Law. Prohibited/controlled weapons(includes those of earlier codes): Personal Concealable Firearms, EMP weapons, Radiation weapons, Non-automatic fire Gauss weapons.",
      6 =>
        "Moderate Law. Prohibited/controlled weapons(includes those of earlier codes): All firearms except Shotguns.",
      7 =>
        "Moderate Law. Prohibited/controlled weapons(includes those of earlier codes): Shotguns.",
      8 =>
        "High Law. Prohibited/controlled weapons(includes those of earlier codes): Blade weapons controlled, open display of weapons prohibited.",
      9 => "High Law. All weapons prohibited outside home.",
      10 => "Extreme Law. Weapon posession prohibited.",
      11 => "Extreme Law. Rigid control of civilian movement.",
      12 => "Extreme Law. Unrestricted invasion of privacy.",
      13 => "Extreme Law. Paramilitary law enforcement.",
      14 => "Extreme Law. Full-fledged police state.",
      15 => "Extreme Law. All facets of daily life rigidly controlled.",
      16 => "Extreme Law. Severe punishment for petty infractions.",
      17 => "Extreme Law. Legalized oppressive practices.",
      18 => "Extreme Law. Routinely oppressive and restrictive."
    },
    tech: %{
      0 =>
        "Technology is practically non-existent amongst the locals. Sticks and stones! Clubs, cudgels, spears, no armour to speak of, magnetic compasses, canoes, rafts, carts, mules, no transmission of information except by runners, no other source of energy but muscles.",
      1 =>
        "Technology is beginning to develop. Metallurgy is being discovered. Availability of daggers, pikes, swords, jack armour, catapults, the abacus, heliographs, galleys, wagons.",
      2 =>
        "Development of the printing press, solid metallurgy, chemistry, logistics. Availability of halberds, broadswords, plate armour, canons, sextants, wind mills.",
      3 =>
        "Discovery of electricity, improvements in metallurgy, navigation. Availability of foils, cutlasses, blades, age of sail, bayonets on primitive rifles, telegraph networks, water wheels.
      ",
      4 =>
        "Discovery of mass production, steam power. Availability of revolvers, shotguns, ironclads, artillery, adding machines, telephones, steam ships, trains, dirigibles, use of coal, development of anaesthetics.
      ",
      5 =>
        "Discovery of radio waves, steel production, computers, combustion engines. Availability of carbines, rifles, pistols, SMGs, steel plating, sandcasters, mortars, Model/1 computers, radios, communicators, motorboats, ground cars, airplanes, use of oil.",
      6 =>
        "Discovery of nuclear energy; a solid understanding of electromagnetic waves; the early space age. Availability of auto rifles, light machine-guns, cloth armour, missiles and missile launchers, Model/1bis computers, television, submersibles, all terrain vehicles (ATV), armoured fighting vehicles (AFV), helicopters, fission power, weather predictions.",
      7 =>
        "Discovery of micro-computing, development of solar power alternatives. Availability of body pistols, mesh armour, flak jackets, pulse lasers, grenade launchers, Model/2 computers, hand calculators, hovercrafts, satellites.",
      8 =>
        "Development of space and nullgrav technology. Availability of laser carbines, snub pistols, vacc suits, auto-cannons, Model/2bis computers, artillery computers, air/rafts, GCarriers, space stations.",
      9 =>
        "Development of jump drives and sophisticated energy weapons. Availability of laser rifles, ablat armour, beam lasers, Model/3 computers, battle computers, limb regeneration, drives A–D, jump drives.",
      10 =>
        "Joining the interstellar community. Availability of reflec armour, Model/4 computers, holovision, grav tanks, drives E-H.",
      11 =>
        "Average imperial tech level. Availability of combat armour, Model/5 computers, hand computers, drives J-K.",
      12 =>
        "Average imperial tech level. Availability of sophisticated combat armour, Model/6 computers, primitive robots, grav belts, drives L–N.",
      13 =>
        "Above average imperial tech level. Availability of battle dress, Model/7 computers, holographic crystals, cloning, drives P–Q.",
      14 => "Above average imperial tech level. Availability of drives R–U.",
      15 =>
        "The locals are at the upper limits of imperial technology. Availability of black globes. Availability of all known drives.",
      16 =>
        "Artificial Persons The widespread availability of artificial persons, practical robots, artificial intelligence in computers, and self-aware mechanisms replaces sophonts in most non-creative activities.",
      17 =>
        "Artificial Persons The widespread availability of artificial persons, practical robots, artificial intelligence in computers, and self-aware mechanisms replaces sophonts in most non-creative activities.",
      18 =>
        "Artificial Persons The widespread availability of artificial persons, practical robots, artificial intelligence in computers, and self-aware mechanisms replaces sophonts in most non-creative activities.",
      19 =>
        "Matter Transport. The availability of elemental matter portals (transporting raw materials across AU distances efficiently) transforms concepts of physical value",
      20 =>
        "Matter Transport. The availability of elemental matter portals (transporting raw materials across AU dis- tances efficiently) transforms concepts of physical value.",
      21 =>
        "Matter Transport. The availability of elemental matter portals (transporting raw materials across AU dis- tances efficiently) transforms concepts of physical value.",
      22 =>
        "Individual Transformations. The lines between individuals blur as bodies become customizable, replace- able, and disposable.",
      23 =>
        "Individual Transformations. The lines between individuals blur as bodies become customizable, replace- able, and disposable.",
      24 =>
        "Individual Transformations. The lines between individuals blur as bodies become customizable, replace- able, and disposable.",
      25 =>
        "Psionic Engineering. Technological tools based on psionic principles revolutionize communications and manufacturing.",
      26 =>
        "Psionic Engineering. Technological tools based on psionic principles revolutionize communications and manufacturing.",
      27 =>
        "Psionic Engineering. Technological tools based on psionic principles revolutionize communications and manufacturing.",
      28 =>
        "Stellar Scale Physical Manipulation. Technology develops capabilities to manipulate worlds and stars: to move them, harvest them for their matter and energy, and convert them to other large scale objects.",
      29 =>
        "Stellar Scale Physical Manipulation. Technology develops capabilities to manipulate worlds and stars: to move them, harvest them for their matter and energy, and convert them to other large scale objects.",
      30 =>
        "Stellar Scale Physical Manipulation. Technology develops capabilities to manipulate worlds and stars: to move them, harvest them for their matter and energy, and convert them to other large scale objects.",
      31 =>
        "Pocket Universes. The ability to create and manipulate pocket universes infinitely expands available resources and turns all but the most adventurous inward.",
      32 =>
        "Pocket Universes. The ability to create and manipulate pocket universes infinitely expands available resources and turns all but the most adventurous inward.",
      33 => "The Technological Singularity. Society reaches a critical point in its development."
    }
  }
  def detailed_world_description(world) do
    {world, %{}}
    |> put_formatted_name()
    |> detailed_uwp_description()

    # |> apply_population_digit()
    # |> put_belts()
    # |> put_gas_giants()
    # |> put_native_life_status()
  end

  defp put_formatted_name({world, desc}) do
    desc =
      Map.put(desc, :name, world.name)
      |> Map.put(:uwp, Formatter.format_world(world))

    {world, desc}
  end

  defp detailed_uwp_description({world, desc}) do
    attributes =
      for {k, v} <- Map.from_struct(world),
          into: %{},
          do: {k, get_attribute_description({k, v})}

    desc = Map.merge(desc, attributes)

    {world, desc}
  end

  defp get_attribute_description({:population, 0}), do: 0
  defp get_attribute_description({:population, v}), do: :math.pow(10, v) |> round()
  defp get_attribute_description({k, v}), do: @data[k][v]

  defp apply_population_digit({world, desc}) when desc.population == 0 do
    desc = %{desc | population: "Uninhabited."}
    {world, desc}
  end

  defp apply_population_digit({world, desc}) do
    population_range =
      (desc.population * world.pbg.population_digit)..(desc.population *
                                                         (world.pbg.population_digit + 1))

    population = Enum.random(population_range) |> Formatter.format_number()
    desc = %{desc | population: population}
    {world, desc}
  end

  defp put_belts({world, desc}) when world.pbg.belts == 1 do
    belts = "There is 1 planetoid belt and"
    desc = Map.put(desc, :belts_and_gas, belts)
    {world, desc}
  end

  defp put_belts({world, desc}) do
    belts = "There are #{world.pbg.belts} planetoid belts and"
    desc = Map.put(desc, :belts_and_gas, belts)
    {world, desc}
  end

  defp put_gas_giants({world, desc}) when world.pbg.gas_giants == 1 do
    gas_giants = "#{desc.belts_and_gas} 1 gas giant in the system."
    desc = %{desc | belts_and_gas: gas_giants}
    {world, desc}
  end

  defp put_gas_giants({world, desc}) do
    gas_giants = "#{desc.belts_and_gas} #{world.pbg.gas_giants} gas giants in the system."
    desc = %{desc | belts_and_gas: gas_giants}
    {world, desc}
  end

  # defp put_base_presence({world, desc}) do
  #   bases =
  #     case world.bases do
  #       %{scout: true, naval: true} -> "Both a naval and scout base are present on this world."
  #       %{scout: false, naval: true} -> "There is a naval base on this world."
  #       %{scout: true, naval: false} -> "There is a scout base on this world."
  #       %{scout: false, naval: false} -> "This world does not have a scout or naval base."
  #     end

  #   desc = Map.put(desc, :bases, bases)
  #   {world, desc}
  # end

  defp put_native_life_status({world, desc}) do
    natives = "#{world.natives.type}. #{world.natives.description}"
    desc = Map.put(desc, :natives, natives)
    {world, desc}
  end
end
