require 'component/component_spec_helper'

describe Space, type: :model do

  describe 'the spaces table' do
    subject { Space.new }
    it { is_expected.to have_db_column(:floor).of_type(:integer) }
    it { is_expected.to have_db_column(:section).of_type(:string) }
    it { is_expected.to have_db_column(:number).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_uniqueness_of(:number).scoped_to([:floor, :section]) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:parking_assignments).dependent(:restrict_with_exception) }
  end

  describe 'scopes' do
    describe '.unavailable' do
      let!(:available_space) { create :space }
      let!(:unavailable_space) { create :space }
      let!(:vehicle) { create :vehicle }

      before do
        create :parking_assignment, space: available_space, vehicle: vehicle, ended_at: Time.zone.now
        create :parking_assignment, space: unavailable_space, vehicle: vehicle
      end

      it 'returns spaces that are currently assigned to a vehicle' do
        expect(Space.unavailable).to eq [unavailable_space]
      end
    end

    describe '.available' do
      let!(:available_space_second) { create :space, floor: 1, section: 'B' }
      let!(:available_space_first) { create :space, floor: 1, section: 'A' }
      let!(:available_space_third) { create :space, floor: 2, section: 'A' }
      let!(:unavailable_space) { create :space }
      let!(:vehicle) { create :vehicle }

      before do
        create :parking_assignment, space: available_space_second, vehicle: vehicle, ended_at: Time.zone.now
        create :parking_assignment, space: unavailable_space, vehicle: vehicle
      end

      it 'returns spaces that are NOT currently assigned to a vehicle' do
        expect(Space.available).to eq [available_space_first,
                                       available_space_second,
                                       available_space_third]
      end
    end
  end

  describe '#identifier' do
    subject { space.identifier }
    let(:space) { create :space, number: 1, floor: floor, section: section }
    let(:floor) { 1 }
    let(:section) { 'A' }

    context "when the space has a number, floor and a section" do
      it { is_expected.to eq '1A-1' }
    end

    context "when the space has a number and floor but no section" do
      let(:section) { nil }
      it { is_expected.to eq '1-1' }
    end

    context "when the space has a number and section but no floor" do
      let(:floor) { nil }
      it { is_expected.to eq 'A-1' }
    end

    context "when the space has a number only" do
      let(:floor) { nil }
      let(:section) { nil }
      it { is_expected.to eq '1' }
    end
  end
end
