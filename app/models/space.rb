class Space < ApplicationRecord

  validates :number, presence: true

  validates :number, uniqueness: { scope: [:floor, :section] }

end
