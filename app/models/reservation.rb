class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  delegate :name, :description, to: :room, prefix: true

  validates :check_in_date, :check_out_date, :num_of_guests, presence: true
  validate :check_in_date_is_in_future
  validate :check_out_date_is_after_check_in_date
  validates :num_of_guests, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :num_of_guests_validation
  
  def num_of_guests_validation
    if num_of_guests.blank? || num_of_guests <= 0
      errors.add(:num_of_guests, "は1以上の値を入力してください")
    end
  end

  def total_price
    (check_out_date - check_in_date).to_i * room.price * num_of_guests
  end

  def total_days
    (check_out_date - check_in_date).to_i
  end

  private

  def check_in_date_is_in_future
    errors.add(:check_in_date, "must be a future date") if check_in_date.present? && check_in_date <= Date.today
  end

  def check_out_date_is_after_check_in_date
    if check_out_date.present? && check_in_date.present? && check_out_date <= check_in_date
      errors.add(:check_out_date, "must be after check-in date")
    end
  end
end
