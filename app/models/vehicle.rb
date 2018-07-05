class Vehicle < ApplicationRecord

  validates :license_state,
            :license_number,
            presence: true

  validates :license_state,
            inclusion: { in: us_state_abbreviations }

  validates :license_number,
            uniqueness: { scope: :license_state,
                          case_sensitive: false,
                          message: "for the given state is already taken. A vehicle with this License Plate is already in the system"}

  validates :license_number,
            format: { with: /\A[a-zA-Z0-9]{4,7}\z/, message: "is invalid format" }

end
