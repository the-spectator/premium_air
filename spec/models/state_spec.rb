RSpec.describe State, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:locations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    context 'when creating a state' do
      it 'is valid with valid attributes' do
        state = build(:state)
        expect(state).to be_valid
      end
    end
  end
end
