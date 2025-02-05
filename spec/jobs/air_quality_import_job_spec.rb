require 'rails_helper'

RSpec.describe AirQualityImportJob, type: :job do
  let(:locations) { create_list(:location, 2) }
  let(:from) { 1.hour.ago }
  let(:to) { Time.current }

  describe "#perform" do
    it "calls importer twice" do
      expect(AirQualityMetricImporter).to receive(:import).twice
      described_class.perform_now([ locations.map(&:id) ], from, to)
    end

    it "queues the job on the importer queue" do
      expect(described_class.new.queue_name).to eq("importer")
    end
  end
end
