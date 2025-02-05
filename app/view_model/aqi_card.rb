class AqiCard
  attr_reader :title, :uk_aqi

  def initialize(title, uk_aqi, pollutants)
    @title = title
    @uk_aqi = uk_aqi
    @pollutants = pollutants
  end

  def pollutants_pills
    @pollutants.map do |name, concentration|
      { name: name, concentration: "#{ActiveSupport::NumberHelper.number_to_rounded(concentration, precision: 2)} μg/m³", class: pill_class(name) }
    end
  end

  def pill_class(pollutant)
    return "bg-red-200 rounded p-1 text-sm font-bold" if pollutant.to_s == uk_aqi[:max_pollutant].to_s
    "p-1"
  end

  def aqi_colour_class
    case uk_aqi[:aqi]
    when (1..3)
      "text-green-500"
    when (4..6)
      "text-yellow-500"
    when (7..9)
      "text-orange-500"
    when (10..)
      "text-red-500"
    end
  end
end
