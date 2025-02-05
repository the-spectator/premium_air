# frozen_string_literal: true

class UkAqi
  ValidationError = Class.new(StandardError)

  POLLUTANT_CONCENTRATION_BANDS = {
    pm2_5: [
      { range: (0..11), aqi: 1 },
      { range: (12..23), aqi: 2 },
      { range: (24..35), aqi: 3 },
      { range: (36..41), aqi: 4 },
      { range: (42..47), aqi: 5 },
      { range: (48..53), aqi: 6 },
      { range: (54..58), aqi: 7 },
      { range: (59..64), aqi: 8 },
      { range: (65..70), aqi: 9 },
      { range: (71..), aqi: 10 }
    ],
    pm10: [
      { range: (0..16), aqi: 1 },
      { range: (17..33), aqi: 2 },
      { range: (34..50), aqi: 3 },
      { range: (51..58), aqi: 4 },
      { range: (59..66), aqi: 5 },
      { range: (67..75), aqi: 6 },
      { range: (76..83), aqi: 7 },
      { range: (84..91), aqi: 8 },
      { range: (92..100), aqi: 9 },
      { range: (101..), aqi: 10 }
    ],
    o3: [
      { range: (0..33), aqi: 1 },
      { range: (34..66), aqi: 2 },
      { range: (67..100), aqi: 3 },
      { range: (101..120), aqi: 4 },
      { range: (121..140), aqi: 5 },
      { range: (141..160), aqi: 6 },
      { range: (161..187), aqi: 7 },
      { range: (188..213), aqi: 8 },
      { range: (214..240), aqi: 9 },
      { range: (241..), aqi: 10 }
    ],
    no2: [
      { range: (0..67), aqi: 1 },
      { range: (68..134), aqi: 2 },
      { range: (135..200), aqi: 3 },
      { range: (201..267), aqi: 4 },
      { range: (268..334), aqi: 5 },
      { range: (335..400), aqi: 6 },
      { range: (401..467), aqi: 7 },
      { range: (468..534), aqi: 8 },
      { range: (535..600), aqi: 9 },
      { range: (601..), aqi: 10 }
    ],
    so2: [
      { range: (0..88), aqi: 1 },
      { range: (89..177), aqi: 2 },
      { range: (178..266), aqi: 3 },
      { range: (267..354), aqi: 4 },
      { range: (355..443), aqi: 5 },
      { range: (444..532), aqi: 6 },
      { range: (533..710), aqi: 7 },
      { range: (711..887), aqi: 8 },
      { range: (888..1064), aqi: 9 },
      { range: (1065..), aqi: 10 }
    ]
  }.freeze

  AQI_BAND = {
    1 => "Low",
    2 => "Low",
    3 => "Low",
    4 => "Moderate",
    5 => "Moderate",
    6 => "Moderate",
    7 => "High",
    8 => "High",
    9 => "High",
    10 => "Very High"
  }.freeze

  CONSIDERED_POLLUTANTS = POLLUTANT_CONCENTRATION_BANDS.keys.freeze

  def initialize(air_quality_metric)
    @pm2_5 = air_quality_metric.pm2_5
    @pm10 = air_quality_metric.pm10
    @o3 = air_quality_metric.o3
    @no2 = air_quality_metric.no2
    @so2 = air_quality_metric.so2
  end

  # The AQI value is the maximum of the AQI values calculated for each pollutant
  def calculate_aqi
    validate!

    aqi_values = [
      [ :pm2_5, aqi_for_pollutant(:pm2_5, pm2_5) ],
      [ :pm10, aqi_for_pollutant(:pm10, pm10) ],
      [ :o3, aqi_for_pollutant(:o3, o3) ],
      [ :no2, aqi_for_pollutant(:no2, no2) ],
      [ :so2, aqi_for_pollutant(:so2, so2) ]
    ]

    max_pollutant, max_aqi = aqi_values.max_by { |_, aqi| aqi }
    { aqi: max_aqi, band: AQI_BAND[max_aqi], pollutant: max_pollutant }
  end

  private

  attr_reader :air_quality_metric, :pm2_5, :pm10, :o3, :no2, :so2

  def validate!
    if pm2_5.nil? || pm10.nil? || o3.nil? || no2.nil? || so2.nil?
      raise ValidationError, "all pollutant values must be provided"
    end

    if [ pm2_5, pm10, o3, no2, so2 ].any? { |value| value.negative? }
      raise ValidationError, "pollutant values can't be negative"
    end
  end

  def aqi_for_pollutant(pollutant, value)
    band = POLLUTANT_CONCENTRATION_BANDS[pollutant].find { |band| band[:range].cover?(value) }
    band[:aqi]
  end
end
