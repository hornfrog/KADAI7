class Room < ApplicationRecord
  belongs_to :user
  attachment :room_image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_then_or_equal_to:1 }
  validates :address, presence: true

  has_many :reservations  
end
