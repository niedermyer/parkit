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

end
