class Location < ApplicationRecord
  has_many :object_locations
  has_many :objects, through: :object_locations
end
