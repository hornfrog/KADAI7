class Room < ApplicationRecord
  belongs_to :user
  attachment :room_image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0  }
  validates :address, presence: true

  has_many :reservations  
end
