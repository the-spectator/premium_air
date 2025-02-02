RSpec.describe Location, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:state) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end
end
