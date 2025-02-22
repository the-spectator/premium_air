require "open_weather"

RSpec.describe AirQualityMetricImporter do
  describe "#import" do
    let(:location) { create(:location, name: "Guwahati", latitude: 26.180598, longitude: 91.753943) }
    let(:start_time) { Time.parse("04 Feb 2025 10:00 AM UTC") }
    let(:end_time) { Time.parse("04 Feb 2025 12:00 PM UTC") }

    subject { described_class.import(location, start_time, end_time) }

    describe "arg validation" do
      context "when location is not given" do
        let(:location) { nil }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::ValidationError, /latitue and longitude can't be empty/)
        end
      end

      context "when latitude is empty" do
        let(:location) { build(:location, name: "Guwahati", latitude: nil, longitude: 91.753943) }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::ValidationError, /latitue and longitude can't be empty/)
        end
      end

      context "when longitude is empty" do
        let(:location) { build(:location, name: "Guwahati", latitude: 26.180598, longitude: nil) }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::ValidationError, /latitue and longitude can't be empty/)
        end
      end

      context "when start_time is not given" do
        let(:start_time) { nil }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::ValidationError, /start_time and end_time can't be empty/)
        end
      end

      context "when end_time is not given" do
        let(:end_time) { nil }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::InvalidDurationError, /start_time and end_time can't be empty/)
        end
      end

      context "when start_time is not a Time object" do
        let(:start_time) { "2025-02-04" }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::InvalidDurationError, /start_time and end_time should be of type Time/)
        end
      end

      context "when end_time is not a Time object" do
        let(:end_time) { "2025-02-04" }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::InvalidDurationError, /start_time and end_time should be of type Time/)
        end
      end

      context "when end_time is before start_time" do
        let(:start_time) { Time.parse("4 Feb 2025 12:00 PM") }
        let(:end_time) { Time.parse("3 Feb 2025 10:00 AM") }

        it "raises validation error" do
          expect { subject }.to raise_error(AirQualityMetricImporter::InvalidDurationError, /start_time can't be greater than end_time/)
        end
      end
    end

    context "for valid args" do
      it "creates metrics", vcr: { cassette_name: "models/air_quality_importer/success" } do
        expect { subject }.to change(AirQualityMetric, :count).from(0).to(3)
        expect(a_request(:get, /#{OpenWeather::Client::BASE_URL}*/)).to have_been_made
      end
    end

    context "when negative value is given" do
      before do
        stub_request(:get, %r{#{OpenWeather::Client::BASE_URL}/data/2.5/air_pollution/history.*})
          .to_return(
            body: '{ "coord": { "lon": 91.7539, "lat": 26.1806 }, "list": [ { "main": { "aqi": 5 }, "components": { "co": 934.6, "no": 0.11, "no2": -99999, "o3": 92.98, "so2": 7.87, "pm2_5": 75.12, "pm10": 91.69, "nh3": 28.12 }, "dt": 1738670400 } ] }',
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "doesn't import invalid record" do
        expect { subject }.not_to change(AirQualityMetric, :count)
      end
    end
  end
end
