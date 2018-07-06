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
    it { is_expected.to validate_inclusion_of(:license_state).in_array(Vehicle.us_state_abbreviations) }


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

  describe 'associations' do
    it { is_expected.to have_many(:parking_assignments).dependent(:restrict_with_exception) }
  end

  describe '.us_states_options' do
    it 'returns an array of arrays containing US states and their abbreviations' do
      expect(Vehicle.us_states_options).to eq [
                                        ['Alabama', 'AL'],
                                        ['Alaska', 'AK'],
                                        ['Arizona', 'AZ'],
                                        ['Arkansas', 'AR'],
                                        ['California', 'CA'],
                                        ['Colorado', 'CO'],
                                        ['Connecticut', 'CT'],
                                        ['Delaware', 'DE'],
                                        ['District of Columbia', 'DC'],
                                        ['Florida', 'FL'],
                                        ['Georgia', 'GA'],
                                        ['Hawaii', 'HI'],
                                        ['Idaho', 'ID'],
                                        ['Illinois', 'IL'],
                                        ['Indiana', 'IN'],
                                        ['Iowa', 'IA'],
                                        ['Kansas', 'KS'],
                                        ['Kentucky', 'KY'],
                                        ['Louisiana', 'LA'],
                                        ['Maine', 'ME'],
                                        ['Maryland', 'MD'],
                                        ['Massachusetts', 'MA'],
                                        ['Michigan', 'MI'],
                                        ['Minnesota', 'MN'],
                                        ['Mississippi', 'MS'],
                                        ['Missouri', 'MO'],
                                        ['Montana', 'MT'],
                                        ['Nebraska', 'NE'],
                                        ['Nevada', 'NV'],
                                        ['New Hampshire', 'NH'],
                                        ['New Jersey', 'NJ'],
                                        ['New Mexico', 'NM'],
                                        ['New York', 'NY'],
                                        ['North Carolina', 'NC'],
                                        ['North Dakota', 'ND'],
                                        ['Ohio', 'OH'],
                                        ['Oklahoma', 'OK'],
                                        ['Oregon', 'OR'],
                                        ['Pennsylvania', 'PA'],
                                        ['Puerto Rico', 'PR'],
                                        ['Rhode Island', 'RI'],
                                        ['South Carolina', 'SC'],
                                        ['South Dakota', 'SD'],
                                        ['Tennessee', 'TN'],
                                        ['Texas', 'TX'],
                                        ['Utah', 'UT'],
                                        ['Vermont', 'VT'],
                                        ['Virginia', 'VA'],
                                        ['Washington', 'WA'],
                                        ['West Virginia', 'WV'],
                                        ['Wisconsin', 'WI'],
                                        ['Wyoming', 'WY']
                                      ]
    end
  end

  describe '.us_state_abbreviations' do
    it 'returns an array state abbreviations' do
      expect(Vehicle.us_state_abbreviations).to eq %w(
                                               AL AK AZ AR CA
                                               CO CT DE DC FL
                                               GA HI ID IL IN
                                               IA KS KY LA ME
                                               MD MA MI MN MS
                                               MO MT NE NV NH
                                               NJ NM NY NC ND
                                               OH OK OR PA PR
                                               RI SC SD TN TX
                                               UT VT VA WA WV
                                               WI WY
                                              )
    end
  end

  describe '#identifier' do
    let(:vehicle) { create :vehicle, license_state: 'NY', license_number: 'AABBCC' }

    it 'returns a identifier string made up of license_state and license_number' do
      expect(vehicle.identifier).to eq 'AABBCC | NY'
    end
  end

  describe '#to_label' do
    let(:vehicle) { create :vehicle, license_state: 'NJ', license_number: 'XYZ000', description: 'Yellow truck'}

    it 'returns a descriptive label made up of license_state, license_number and description' do
      expect(vehicle.to_label).to eq 'XYZ000 | NJ | Yellow truck'
    end
  end
end
