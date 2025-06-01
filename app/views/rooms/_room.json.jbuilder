json.extract! room, :id, :name, :room_type_id, :descriptions, :created_at, :updated_at
json.url room_url(room, format: :json)
