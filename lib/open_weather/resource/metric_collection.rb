# frozen_string_literal: true

module OpenWeather
  module Resource
    class MetricCollection
      private attr_reader :json

      def initialize(response)
        @json = response.body
      end

      def coordinates
        @coordinates ||= Resource::Coordinate.new(json["coord"])
      end

      def metrics
        @metrics ||= json["list"].map { |metric| Metric.new(metric) }
      end

      # NOTE: had to override inspect because of too verbose output
      def inspect
        "#<#{self.class.name}:#{object_id} coord=#{coordinates.inspect} metrics=#{metrics.inspect}>"
      end
    end
  end
end
