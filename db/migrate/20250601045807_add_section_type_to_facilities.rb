class AddSectionTypeToFacilities < ActiveRecord::Migration[8.0]
  def change
    add_column :facilities, :section_type, :string
  end
end
