class Booking < ApplicationRecord
  belongs_to :customer
  has_many :booking_rooms, dependent: :destroy
  has_many :rooms, through: :booking_rooms

  # Enum for payment methods
  enum :payment_method, {
    credit_card: 0,
    cash: 1,
    bank_transfer: 2,
    online_payment: 3
  }

  # Validations
  validates :start_date, presence: true
  validates :finish_date, presence: true
  validates :payment_method, presence: true
  validate :finish_date_after_start_date

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "start_date", "finish_date", "payment_method", "customer_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "customer", "rooms" ]
  end

  # Calculate total days
  def total_days
    return 0 unless start_date && finish_date
    (finish_date - start_date).to_i
  end

  # Calculate total amount
  def total_amount
    return 0 unless rooms.any?
    rooms.sum(:price) * total_days
  end

  private

  def finish_date_after_start_date
    return unless start_date && finish_date

    errors.add(:finish_date, "must be after start date") if finish_date <= start_date
  end
end
