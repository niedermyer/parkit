require 'component/component_spec_helper'

describe ParkingAssignment, type: :model do

  describe 'the parking_assignments table' do
    subject { ParkingAssignment.new }
    it { is_expected.to have_db_column(:space_id).of_type(:integer) }
    it { is_expected.to have_db_column(:vehicle_id).of_type(:integer) }
    it { is_expected.to have_db_column(:started_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:ended_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:space_id) }
    it { is_expected.to have_db_index(:vehicle_id) }
    it { is_expected.to have_db_index([:space_id, :ended_at]).unique } # DB constraint to ensure only one active assignment per space

    it { is_expected.to have_db_foreign_key(:space_id) }
    it { is_expected.to have_db_foreign_key(:vehicle_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:space) }
    it { is_expected.to validate_presence_of(:vehicle) }
    it { is_expected.to validate_presence_of(:started_at) }

    it 'should validate that :space is unique within the scope of :ended_at' do
      space = create :space
      parking_assignment = ParkingAssignment.new(space: space)
      expect(parking_assignment).to validate_uniqueness_of(:space).scoped_to(:ended_at)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:space) }
    it { is_expected.to belong_to(:vehicle) }

    it { is_expected.to delegate_method(:identifier).to(:space).with_prefix }
    it { is_expected.to delegate_method(:floor).to(:space).with_prefix }
    it { is_expected.to delegate_method(:section).to(:space).with_prefix }
    it { is_expected.to delegate_method(:number).to(:space).with_prefix }
    it { is_expected.to delegate_method(:identifier).to(:vehicle).with_prefix }
    it { is_expected.to delegate_method(:to_label).to(:vehicle).with_prefix }
    it { is_expected.to delegate_method(:description).to(:vehicle).with_prefix }
    it { is_expected.to delegate_method(:contact_name).to(:vehicle).with_prefix }
    it { is_expected.to delegate_method(:contact_phone).to(:vehicle).with_prefix }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:archived_assignment) { create :parking_assignment, ended_at: Time.zone.now }
      let!(:active_assignment) { create :parking_assignment, ended_at: nil }

      it 'returns parking assignments that are currently active (assigned a vehicle)' do
        expect(ParkingAssignment.active).to eq [active_assignment]
      end
    end
  end

  describe '#active?' do
    subject{ assignment.active? }
    let!(:assignment) { create :parking_assignment, ended_at: ended_at }

    context 'when the parking assignment has NOT ended' do
      let(:ended_at) { nil }

      it { is_expected.to be true }
    end

    context 'when the parking assignment has ended' do
      let(:ended_at) { Time.zone.now }

      it { is_expected.to be false }
    end
  end

end
