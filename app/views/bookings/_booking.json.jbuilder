json.extract! booking, :id, :customer_id, :start_date, :finish_date, :payment_method, :created_at, :updated_at
json.url booking_url(booking, format: :json)
