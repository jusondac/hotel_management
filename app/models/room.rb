class Room < ApplicationRecord
  belongs_to :room_type
  has_many :room_facilities, dependent: :destroy
  has_many :facilities, through: :room_facilities
  has_many :booking_rooms, dependent: :destroy
  has_many :bookings, through: :booking_rooms

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :available, -> { where(available: true) }
  scope :by_room_type, ->(room_type_id) { where(room_type_id: room_type_id) }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "price", "available", "description", "room_type_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "room_type", "facilities" ]
  end

  # Check if room is available for given date range
  def available_for_dates?(start_date, finish_date)
    return false unless available?

    conflicting_bookings = bookings.where(
      "(start_date <= ? AND finish_date > ?) OR (start_date < ? AND finish_date >= ?)",
      start_date, start_date, finish_date, finish_date
    )

    conflicting_bookings.empty?
  end

  # Get facility names as a string
  def facility_names
    facilities.pluck(:name).join(", ")
  end
end
