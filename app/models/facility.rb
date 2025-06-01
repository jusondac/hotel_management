class Facility < ApplicationRecord
  has_many :room_facilities, dependent: :destroy
  has_many :rooms, through: :room_facilities

  # Enum for section types
  enum :section_type, {
    room: 0,
    gym: 1,
    spa: 2,
    restaurant: 3,
    business: 4,
    entertainment: 5,
    outdoor: 6,
    common_area: 7
  }

  # Validations
  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :section_type, presence: true

  # Scopes
  scope :by_section, ->(section) { where(section_type: section) }
  scope :room_facilities, -> { where(section_type: "room") }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "section_type", "quantity" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "rooms" ]
  end

  # Helper methods
  def section_type_badge_color
    case section_type
    when "room" then "bg-blue-100 text-blue-800"
    when "gym" then "bg-green-100 text-green-800"
    when "spa" then "bg-purple-100 text-purple-800"
    when "restaurant" then "bg-orange-100 text-orange-800"
    when "business" then "bg-gray-100 text-gray-800"
    when "entertainment" then "bg-pink-100 text-pink-800"
    when "outdoor" then "bg-emerald-100 text-emerald-800"
    when "common_area" then "bg-indigo-100 text-indigo-800"
    else "bg-gray-100 text-gray-800"
    end
  end
end
