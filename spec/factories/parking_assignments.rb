FactoryBot.define do

  factory :parking_assignment do
    space
    vehicle
    started_at { Time.zone.now }
  end

end
