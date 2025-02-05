RSpec.describe AirQualityMetric, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:location) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:so2) }
    it { is_expected.to validate_presence_of(:no2) }
    it { is_expected.to validate_presence_of(:pm2_5) }
    it { is_expected.to validate_presence_of(:pm10) }
    it { is_expected.to validate_presence_of(:o3) }
    it { is_expected.to validate_presence_of(:recorded_at) }

    it { is_expected.to validate_numericality_of(:so2).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:no2).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:pm2_5).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:pm10).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:o3).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:nh3).is_greater_than_or_equal_to(0) }

    context "with valid attributes" do
      subject { build(:air_quality_metric, location: create(:location)) }

      it { is_expected.to validate_uniqueness_of(:recorded_at).scoped_to(:location_id) }

      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end

      it 'is not valid without a recorded_at' do
        subject.recorded_at = nil
        expect(subject).to_not be_valid
      end

      it 'is not valid if recorded_at is in the future' do
        subject.recorded_at = Time.current + 1.day
        expect(subject).to_not be_valid
        expect(subject.errors[:recorded_at]).to include("can't be in the future")
      end
    end
  end

  describe "#uk_aqi" do
    let(:metric) { build(:air_quality_metric, location: create(:location), co: 627.52, no: 0.0, no2: 15.25, o3: 23.25, so2: 2.62, pm2_5: 49.06, pm10: 61.99, nh3: 23.05) }

    subject { metric.aqi }

    it "gives the aqi hash" do
      result = subject
      expect(result[:aqi]).to eq(6)
      expect(result[:band]).to eq("Moderate")
      expect(result[:max_pollutant]).to eq(:pm2_5) # Highest AQI pollutant
    end
  end

  describe "#uk_standard_pollutants" do
    let(:metric) { build(:air_quality_metric, location: create(:location), co: 627.52, no: 0.0, no2: 15.25, o3: 23.25, so2: 2.62, pm2_5: 49.06, pm10: 61.99, nh3: 23.05) }

    subject { metric.uk_standard_pollutants }

    it "gives uk_standard_pollutants" do
      expect(subject.keys).to match_array(%w[pm2_5 pm10 o3 no2 so2])
    end
  end
end
