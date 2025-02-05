module AqiHelper
  TABLE_HEADER = [ "Location", "Latest Recorded AQI", "Average Recorded AQI", "Action" ]

  def formatted_stat(count)
    number_to_human(
      count,
      precision: 1, significant: false, round_mode: :down, format: "%n%u",
      units: { thousand: "K", million: "M", billion: "B" }
    )
  end
end
