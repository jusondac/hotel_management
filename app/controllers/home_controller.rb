class HomeController < ApplicationController
  def index
    if Current.user
      @total_rooms = Room.count
      @available_rooms = Room.available.count
      @total_bookings = Booking.count
      @upcoming_bookings = Booking.where("start_date > ?", Date.current).count
      @total_customers = Customer.count
      @recent_bookings = Booking.includes(:customer, :rooms).order(created_at: :desc).limit(5)
      @room_types = RoomType.includes(:rooms).all
      @monthly_revenue = calculate_monthly_revenue
    end
  end

  private

  def calculate_monthly_revenue
    current_month_bookings = Booking.joins(:rooms)
                                   .where("start_date >= ? AND start_date <= ?",
                                          Date.current.beginning_of_month,
                                          Date.current.end_of_month)

    current_month_bookings.sum do |booking|
      booking.total_amount
    end
  end
end
