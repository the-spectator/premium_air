class Location < ApplicationRecord
  # Associations
  belongs_to :state

  # Validations
  validates :name, :latitude, :longitude, presence: true
end
