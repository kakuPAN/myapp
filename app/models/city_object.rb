class CityObject < ApplicationRecord
  has_many :object_locations
  has_many :locations, through: :object_locations
end
