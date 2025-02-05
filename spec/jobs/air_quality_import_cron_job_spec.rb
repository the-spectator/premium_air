require 'rails_helper'

RSpec.describe AirQualityImportCronJob, type: :job do
  describe "#perform" do
    let(:locations) { create_list(:location, 15) }
    let(:from) { 1.hour.ago }
    let(:to) { Time.current }

    before do
      locations
      allow(Time).to receive(:current).and_return(to)
    end

    it "enqueues AirQualityImportJob for each batch of locations" do
      expect {
        described_class.perform_now
      }.to have_enqueued_job(AirQualityImportJob).twice.on_queue("importer") # 2 batches = 10 loc + 5 loc
    end

    it "queues the job on the importer queue" do
      expect(described_class.new.queue_name).to eq("importer")
    end
  end
end
