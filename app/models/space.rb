class Space < ApplicationRecord

  has_many :parking_assignments, dependent: :restrict_with_exception

  validates :number, presence: true

  validates :number, uniqueness: { scope: [:floor, :section] }

  def identifier
    prefix = "#{floor}#{section}"
    [prefix.presence, number].compact.join('-')
  end
end
