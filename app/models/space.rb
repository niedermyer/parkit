class Space < ApplicationRecord

  validates :number, presence: true

  validates :number, uniqueness: { scope: [:floor, :section] }

  def identifier
    prefix = "#{floor}#{section}"
    [prefix.presence, number].compact.join('-')
  end
end
