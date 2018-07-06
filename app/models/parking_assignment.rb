class ParkingAssignment < ApplicationRecord
  belongs_to :space
  belongs_to :vehicle

  validates :space,
            :vehicle,
            :started_at, presence: true

  validates :space, uniqueness: { scope: :ended_at }

  scope :active, ->{ where( ended_at: nil ) }

end
