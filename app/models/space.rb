class Space < ApplicationRecord

  has_many :parking_assignments, dependent: :restrict_with_exception

  validates :number, presence: true

  validates :number, uniqueness: { scope: [:floor, :section] }

  scope :unavailable, ->{ joins(:parking_assignments).where('parking_assignments.ended_at IS NULL') }
  scope :available, ->{ where.not(id: unavailable.map(&:id)).order( floor: :asc, section: :asc ) }

  def identifier
    prefix = "#{floor}#{section}"
    [prefix.presence, number].compact.join('-')
  end
end
