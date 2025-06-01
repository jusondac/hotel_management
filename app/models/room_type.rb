class RoomType < ApplicationRecord
  # Validations
  validates :name, presence: true
  has_many :rooms, dependent: :destroy
  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end