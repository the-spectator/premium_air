require 'open_weather'

RSpec.describe OpenWeather::Api::GeoCoding do
  let(:api_key) { Rails.application.credentials.open_weather[:api_key] }
  let(:base_url) { OpenWeather::Client::BASE_URL }
  let(:client) { OpenWeather::Client.new(api_key: api_key).geo_coding }

  describe "#get" do
    subject { client.get(city, state) }

    context "for valid query" do
      let(:city) { "wagholi" }
      let(:state) { "maharashtra" }

      it "return result", vcr: { cassette_name: "open_weather/geo_coding/success" } do
        result = subject.body

        expect(result.any? { |r| r['name'].downcase == city }).to be_truthy
        expect(result.first.keys).to include("name", "lat", "lon", "country", "state")
        expect(a_request(:get, %r{#{base_url}/geo/1.0/direct.*q=#{city},#{state}*})).to have_been_made
      end
    end

    context "for invalid query" do
      let(:city) { nil }
      let(:state) { nil }

      it "return error for empty query", vcr: { cassette_name: "open_weather/geo_coding/fail" } do
        expect { subject }.to raise_error(OpenWeather::ClientError)
        expect(a_request(:get, %r{#{base_url}/geo/1.0/direct.*})).to have_been_made
      end
    end
  end
end
