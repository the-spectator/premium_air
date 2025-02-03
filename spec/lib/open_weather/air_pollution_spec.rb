require 'open_weather'

RSpec.describe OpenWeather::Api::AirPollution do
  let(:api_key) { Rails.application.credentials.open_weather[:api_key] }
  let(:base_url) { OpenWeather::Client::BASE_URL }
  let(:client) { OpenWeather::Client.new(api_key: api_key).air_pollution }

  let(:lat) { 17.902781 }
  let(:lon) { 74.081413 }

  shared_examples "air pollution endpoint" do |vcr_path|
    it "returns the air_pollution metric collection", vcr: { cassette_name: "#{vcr_path}/success" } do
      response = subject
      expect(response).to be_an_instance_of(OpenWeather::Resource::MetricCollection)
      expect(response.metrics).to all(be_an_instance_of(OpenWeather::Resource::Metric))
      expect(response.coordinate).to be_an_instance_of(OpenWeather::Resource::Coordinate)
    end

    context "when lat and lon are invalid", vcr: { cassette_name: "#{vcr_path}/invalid_lat_lon" } do
      let(:lat) { 200 }
      let(:lon) { 200 }

      it "raises a client error" do
        expect { subject }.to raise_error(OpenWeather::ClientError, "wrong latitude")
      end
    end

    context "when lat and lon are missing", vcr: { cassette_name: "#{vcr_path}/get_missing_lat_lon" } do
      let(:lat) { nil }
      let(:lon) { 74.081413 }

      it "raises a client error" do
        expect { subject }.to raise_error(OpenWeather::ClientError, "Nothing to geocode")
      end
    end
  end

  describe "#get" do
    subject { client.get(lat, lon) }

    it_behaves_like "air pollution endpoint", "open_weather/air_pollution/get"
  end

  describe "#history" do
    let(:start_time) { Time.parse("01-01-2025 00:00 UTC").to_i }
    let(:end_time) { Time.parse("31-01-2025 00:00 UTC").to_i }

    subject { client.history(lat, lon, start_time, end_time) }

    it_behaves_like "air pollution endpoint", "open_weather/air_pollution/history"

    context "when start date is missing", vcr: { cassette_name: "open_weather/air_pollution/history/missing_start" } do
      let(:start_time) { nil }

      it "raises a client error" do
        expect { subject }.to raise_error(OpenWeather::ClientError, "no location or time specified")
      end
    end

    context "when end date is missing", vcr: { cassette_name: "open_weather/air_pollution/history/get_missing_end" } do
      let(:end_time) { nil }

      it "raises a client error" do
        expect { subject }.to raise_error(OpenWeather::ClientError, "no location or time specified")
      end
    end
  end
end
