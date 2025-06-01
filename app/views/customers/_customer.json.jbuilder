json.extract! customer, :id, :email, :full_name, :address, :city, :created_at, :updated_at
json.url customer_url(customer, format: :json)
