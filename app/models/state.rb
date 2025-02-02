class State < ApplicationRecord
  # Associations
  has_many :locations

  # Validations
  validates :name, presence: true

  # NOTE: Only supports India for now
  def country
    "India"
  end
end
