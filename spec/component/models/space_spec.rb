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
