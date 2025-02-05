require 'open_weather'

RSpec.describe OpenWeather::Client do
  let(:api_key) { "test_api_key" }
  let(:base_url) { OpenWeather::Client::BASE_URL }
  let(:client) { described_class.new(api_key: api_key) }

  describe "#air_pollution" do
    it "returns the air_pollution api wrapper instance" do
      expect(client.air_pollution).to be_an_instance_of(OpenWeather::Api::AirPollution)
    end

    it "returns the air_pollution api wrapper instance" do
      expect(client.geo_coding).to be_an_instance_of(OpenWeather::Api::GeoCoding)
    end
  end

  describe "raises client error on 4xx status" do
    context "when the API key is invalid", vcr: { cassette_name: "open_weather/air_pollution/get_invalid_api_key" } do
      let(:api_key) { "invalid_api_key" }
      let(:client) { OpenWeather::Client.new(api_key: api_key) }

      it "raises a client error" do
        expect { client.get_request("/data/2.5/air_pollution", params: { lat: 17.902781, lon: 74.081413 }) }.to raise_error(OpenWeather::ClientError)
      end
    end

    context "when params are invalid" do
      let(:stub_client_error) do
        stub_request(:get, /#{base_url}*/).to_return(
          status: 400,
          body: {
            "cod": 400,
            "message": "Invalid date format",
            "parameters": [
                "date"
            ]
          }.to_json
        )
      end

      before { stub_client_error }

      it "raises client error" do
        expect { client.get_request("/data/2.5/air_pollution", params: { lat: 17.902781, lon: 74.081413 }) }.to raise_error(OpenWeather::ClientError)
      end
    end
  end

  describe "raises client error on 5xx status" do
    let(:stub_client_error) do
      stub_request(:get, /#{base_url}*/).to_return(
        status: 500,
        body: {
          "cod": 500,
          "message": "Something went wrong"
        }.to_json
      )
    end

    before { stub_client_error }

    it "raises client error" do
      expect { client.get_request("/data/2.5/air_pollution", params: { lat: 17.902781, lon: 74.081413 }) }.to raise_error(OpenWeather::ServerError)
    end
  end

  describe "retries on timeout" do
    let(:stub_server_unavailable) do
      stub_request(:get, /#{base_url}*/).to_timeout
    end

    before { stub_server_unavailable }

    it "retries 3 times", vcr: { cassette_name: "open_weather/retry" } do
      expect { client.get_request("/data/2.5/air_pollution", params: { lat: 17.902781, lon: 74.081413 }) }.to raise_error(Faraday::ConnectionFailed)

      # NOTE: 3 retries = 1 original + 2 retries
      expect(a_request(:get, /#{base_url}*/)).to have_been_made.times(3)
    end
  end
end
