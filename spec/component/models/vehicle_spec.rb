require 'component/component_spec_helper'

describe Vehicle, type: :model do

  describe 'the vehicles table' do
    subject { Vehicle.new }
    it { is_expected.to have_db_column(:license_state).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:license_number).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:contact_name).of_type(:string) }
    it { is_expected.to have_db_column(:contact_phone).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:license_state) }
    it { is_expected.to validate_presence_of(:license_number) }


    it 'should validate that :license_number is case-insensitively unique within the scope of :license_state' do
      vehicle = Vehicle.new(license_state: 'PA', license_number: 'ABC123')
      expect(vehicle).to validate_uniqueness_of(:license_number).scoped_to(:license_state).with_message('for the given state is already taken. A vehicle with this License Plate is already in the system').case_insensitive
    end

    it 'should validate that :license_number is a valid format' do
      vehicle = Vehicle.new

      expect(vehicle).to allow_value('ABC1234').for(:license_number)
      expect(vehicle).to allow_value('ABCDEFG').for(:license_number)
      expect(vehicle).to allow_value('1234567').for(:license_number)
      expect(vehicle).to allow_value('1234').for(:license_number)
      expect(vehicle).to allow_value('abcd').for(:license_number)

      expect(vehicle).not_to allow_value('abc').for(:license_number)      # too short
      expect(vehicle).not_to allow_value('abcd1234').for(:license_number) # too long
      expect(vehicle).not_to allow_value('ABC 123').for(:license_number)  # contains space
      expect(vehicle).not_to allow_value('ABC-123').for(:license_number)  # contains dash
      expect(vehicle).not_to allow_value('*ABC123').for(:license_number)  # starts with special character
      expect(vehicle).not_to allow_value('ABC123-').for(:license_number)  # ends with special character
    end
  end

end
