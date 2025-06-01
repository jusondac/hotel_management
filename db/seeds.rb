# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create admin user
admin_user = User.find_or_create_by!(email_address: "admin@hotel.com") do |user|
  user.password = "password123"
  user.username = "admin"
end
puts "✅ Created admin user: #{admin_user.email_address}"

# Create room types
room_types_data = [
  { name: "Standard Single" },
  { name: "Standard Double" },
  { name: "Deluxe Suite" },
  { name: "Executive Suite" },
  { name: "Presidential Suite" }
]

room_types_data.each do |room_type_data|
  room_type = RoomType.find_or_create_by!(name: room_type_data[:name])
  puts "✅ Created room type: #{room_type.name}"
end

# Create facilities
facilities_data = [
  { name: "WiFi", quantity: 1, section_type: "room" },
  { name: "Air Conditioning", quantity: 1, section_type: "room" },
  { name: "TV", quantity: 1, section_type: "room" },
  { name: "Mini Bar", quantity: 1, section_type: "room" },
  { name: "Safe", quantity: 1, section_type: "room" },
  { name: "Balcony", quantity: 1, section_type: "room" },
  { name: "Ocean View", quantity: 1, section_type: "room" },
  { name: "Jacuzzi", quantity: 1, section_type: "spa" },
  { name: "Fitness Center", quantity: 1, section_type: "gym" },
  { name: "Swimming Pool", quantity: 1, section_type: "outdoor" },
  { name: "Restaurant", quantity: 1, section_type: "restaurant" },
  { name: "Business Center", quantity: 1, section_type: "business" }
]

facilities_data.each do |facility_data|
  facility = Facility.find_or_create_by!(name: facility_data[:name]) do |f|
    f.quantity = facility_data[:quantity]
    f.section_type = facility_data[:section_type]
  end
  puts "✅ Created facility: #{facility.name} (#{facility.section_type})"
end

# Create rooms
rooms_data = [
  { name: "Room 101", price: 120.0, room_type: "Standard Single", facilities: [ "WiFi", "Air Conditioning", "TV" ] },
  { name: "Room 102", price: 150.0, room_type: "Standard Double", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar" ] },
  { name: "Room 201", price: 250.0, room_type: "Deluxe Suite", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar", "Safe", "Balcony" ] },
  { name: "Room 202", price: 300.0, room_type: "Executive Suite", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar", "Safe", "Balcony", "Ocean View" ] },
  { name: "Room 301", price: 500.0, room_type: "Presidential Suite", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar", "Safe", "Balcony", "Ocean View", "Jacuzzi" ] },
  { name: "Room 103", price: 120.0, room_type: "Standard Single", facilities: [ "WiFi", "Air Conditioning", "TV" ] },
  { name: "Room 104", price: 150.0, room_type: "Standard Double", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar" ] },
  { name: "Room 203", price: 250.0, room_type: "Deluxe Suite", facilities: [ "WiFi", "Air Conditioning", "TV", "Mini Bar", "Safe", "Balcony" ] }
]

rooms_data.each do |room_data|
  room_type = RoomType.find_by!(name: room_data[:room_type])
  room = Room.find_or_create_by!(name: room_data[:name]) do |r|
    r.price = room_data[:price]
    r.room_type = room_type
    r.description = "Comfortable #{room_data[:room_type].downcase} with modern amenities"
    r.available = true
  end

  # Add facilities to room
  room_data[:facilities].each do |facility_name|
    facility = Facility.find_by!(name: facility_name)
    RoomFacility.find_or_create_by!(room: room, facility: facility)
  end

  puts "✅ Created room: #{room.name} (#{room.room_type.name}) - $#{room.price}"
end

# Create sample customers
customers_data = [
  { email: "john.doe@email.com", full_name: "John Doe", address: "123 Main St", city: "New York" },
  { email: "jane.smith@email.com", full_name: "Jane Smith", address: "456 Oak Ave", city: "Los Angeles" },
  { email: "mike.johnson@email.com", full_name: "Mike Johnson", address: "789 Pine Rd", city: "Chicago" },
  { email: "sarah.wilson@email.com", full_name: "Sarah Wilson", address: "321 Elm St", city: "Miami" }
]

customers_data.each do |customer_data|
  customer = Customer.find_or_create_by!(email: customer_data[:email]) do |c|
    c.full_name = customer_data[:full_name]
    c.address = customer_data[:address]
    c.city = customer_data[:city]
  end
  puts "✅ Created customer: #{customer.full_name}"
end

# Create sample bookings
bookings_data = [
  {
    customer_email: "john.doe@email.com",
    start_date: Date.current + 1.week,
    finish_date: Date.current + 1.week + 3.days,
    payment_method: 0,
    room_names: [ "Room 101" ]
  },
  {
    customer_email: "jane.smith@email.com",
    start_date: Date.current + 2.weeks,
    finish_date: Date.current + 2.weeks + 5.days,
    payment_method: 1,
    room_names: [ "Room 201" ]
  },
  {
    customer_email: "mike.johnson@email.com",
    start_date: Date.current + 3.weeks,
    finish_date: Date.current + 3.weeks + 2.days,
    payment_method: 0,
    room_names: [ "Room 102", "Room 103" ]
  }
]

bookings_data.each do |booking_data|
  customer = Customer.find_by!(email: booking_data[:customer_email])
  booking = Booking.find_or_create_by!(
    customer: customer,
    start_date: booking_data[:start_date],
    finish_date: booking_data[:finish_date]
  ) do |b|
    b.payment_method = booking_data[:payment_method]
  end

  # Add rooms to booking
  booking_data[:room_names].each do |room_name|
    room = Room.find_by!(name: room_name)
    BookingRoom.find_or_create_by!(booking: booking, room: room)
  end

  puts "✅ Created booking for #{customer.full_name}: #{booking.start_date} to #{booking.finish_date}"
end

puts "🎉 Seeding completed successfully!"
