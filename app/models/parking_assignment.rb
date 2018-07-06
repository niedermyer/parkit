class ParkingAssignment < ApplicationRecord
  belongs_to :space
  belongs_to :vehicle

  validates :space,
            :vehicle,
            :started_at, presence: true

  validates :space, uniqueness: { scope: :ended_at }

  scope :active, ->{ where( ended_at: nil ) }

  delegate :identifier,
           :floor,
           :section,
           :number,
           to: :space,
           prefix: true

  delegate :identifier,
           :to_label,
           :description,
           :contact_name,
           :contact_phone,
           to: :vehicle,
           prefix: true

  def active?
    ended_at.blank?
  end
end
