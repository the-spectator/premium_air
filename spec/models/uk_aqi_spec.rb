RSpec.describe UkAqi, type: :model do
  let(:valid_pollutants) do
    { co: 640.87, no: 0, no2: 14.57, o3: 50.78, so2: 7.09, pm2_5: 37.57, pm10: 52.59, nh3: 34.45 }
  end

  let(:pollutants) { valid_pollutants }

  let(:metric) do
    build(:air_quality_metric, **pollutants)
  end

  describe "#calculate_aqi" do
    subject { described_class.new(metric).calculate_aqi }

    context "with invalid data" do
      UkAqi::CONSIDERED_POLLUTANTS.each do |pollutant|
        context "when #{pollutant} pollutant is nil" do
          let(:pollutants) do
            valid_pollutants.merge(pollutant => nil)
          end

          it "raises ValidationError" do
            expect { subject }.to raise_error(UkAqi::ValidationError, /all pollutant values must be provided/)
          end
        end

        context "when pollutant is negative" do
          let(:pollutants) do
            valid_pollutants.merge(pollutant => valid_pollutants[pollutant] * -1)
          end

          it "raises ValidationError" do
            expect { subject }.to raise_error(UkAqi::ValidationError, /pollutant values can't be negative/)
          end
        end
      end
    end

    context "with valid data" do
      context "when non considered pollutants are empty" do
        [ :co, :no, :nh3 ].each do |pollutant|
          context "when #{pollutant} pollutant is nil" do
            let(:pollutants) do
              valid_pollutants.merge(pollutant => nil)
            end

            it "doesn't raises ValidationError" do
              expect { subject }.not_to raise_error
            end
          end

          context "when pollutant is negative" do
            let(:pollutants) do
              valid_pollutants.merge(pollutant => valid_pollutants[pollutant] * -1)
            end

            it "doesn't raises ValidationError" do
              expect { subject }.not_to raise_error
            end
          end
        end
      end

      context "for low aqi" do
        let(:pollutants) do
          { co: 587.46, no: 0.04, no2: 14.22, o3: 11.98, so2: 1.33, pm2_5: 32.98, pm10: 43.09, nh3: 18.75 }
        end

        it 'returns the correct AQI and band' do
          result = subject
          expect(result[:aqi]).to eq(3)
          expect(result[:band]).to eq("Low")
          expect(result[:max_pollutant]).to eq(:pm2_5)
        end
      end

      context "for moderate aqi" do
        let(:pollutants) do
          { co: 627.52, no: 0.0, no2: 15.25, o3: 23.25, so2: 2.62, pm2_5: 49.06, pm10: 61.99, nh3: 23.05 }
        end

        it 'returns the correct AQI and band' do
          result = subject
          expect(result[:aqi]).to eq(6)
          expect(result[:band]).to eq("Moderate")
          expect(result[:max_pollutant]).to eq(:pm2_5) # Highest AQI pollutant
        end
      end

      context "for high aqi" do
        let(:pollutants) do
          { co: 667.57, no: 0.0, no2: 16.11, o3: 38.27, so2: 5.6, pm2_5: 62.57000000000001, pm10: 78.03, nh3: 25.59 }
        end

        it 'returns the correct AQI and band' do
          result = subject
          expect(result[:aqi]).to eq(8)
          expect(result[:band]).to eq("High")
          expect(result[:max_pollutant]).to eq(:pm2_5)
        end
      end

      context "for very high aqi" do
        let(:pollutants) do
          { co: 560.76, no: 0.0, no2: 5.27, o3: 110.15, so2: 3.61, pm2_5: 110.69, pm10: 136.72, nh3: 4.94 }
        end

        it 'returns the correct AQI and band' do
          result = subject
          expect(result[:aqi]).to eq(10)
          expect(result[:band]).to eq("Very High")
          expect(result[:max_pollutant]).to eq(:pm2_5)
        end
      end

      context "for 0s" do
        let(:pollutants) do
          { co: 0, no: 0, no2: 0, o3: 0, so2: 0, pm2_5: 0, pm10: 0, nh3: 0 }
        end

        it "handles lower boundary values correctly" do
          result = subject
          expect(result[:aqi]).to eq(1)
          expect(result[:band]).to eq("Low")
          expect(result[:max_pollutant]).to eq(:pm2_5)
        end
      end

      context "for boundary values between ranges" do
        let(:pollutants) do
          { pm2_5: 53.64, pm10: 59.43, o3: 141.62, no2: 2.12, so2: 4.23 }
        end

        it "handles lower boundary values correctly" do
          result = subject
          expect(result[:aqi]).to eq(6)
          expect(result[:band]).to eq("Moderate")
          expect(result[:max_pollutant]).to eq(:pm2_5)
        end
      end
    end
  end
end
