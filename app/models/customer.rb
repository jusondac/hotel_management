class Customer < ApplicationRecord
  has_many :bookings, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :address, presence: true
  validates :city, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "email", "full_name", "address", "city" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "bookings" ]
  end

  # Get customer's total bookings count
  def total_bookings
    bookings.count
  end

  # Get customer's upcoming bookings
  def upcoming_bookings
    bookings.where("start_date > ?", Date.current)
  end
end
