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
end
