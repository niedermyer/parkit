FactoryBot.define do

  factory :vehicle do
    license_state 'PA'
    sequence(:license_number) {|n| "ABC1#{n}" }
  end

end
