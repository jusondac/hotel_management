class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings
  def index
    @q = Booking.ransack(params[:q])
    @pagy, @bookings = pagy(@q.result(distinct: true).order(created_at: :desc))
    @booking_form = Booking.new
  end

  # GET /bookings/1
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to bookings_path, notice: "Booking was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      redirect_to bookings_path, notice: "Booking was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy!
    redirect_to bookings_path, notice: "Booking was successfully destroyed.", status: :see_other
  end

  # GET /reservations/new
  def new_reservation
    @booking = Booking.new
    @customer = Customer.new
    @room_types = RoomType.all

    # Build rooms query with filters
    @rooms = Room.available.includes(:room_type, :facilities)

    # Filter by room type if specified
    if params[:room_type_id].present?
      @rooms = @rooms.where(room_type_id: params[:room_type_id])
    end

    # Filter by price range if specified
    if params[:min_price].present?
      @rooms = @rooms.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @rooms = @rooms.where("price <= ?", params[:max_price])
    end

    # Convert to array for date filtering if needed
    rooms_array = @rooms.to_a

    # Filter by availability for specific dates if provided
    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        rooms_array = rooms_array.select { |room| room.available_for_dates?(start_date, end_date) }
      rescue Date::Error
        # Invalid date format, ignore date filter
      end
    end

    @rooms = rooms_array
  end

  # POST /reservations
  def create_reservation
    ActiveRecord::Base.transaction do
      # Create or find customer
      @customer = Customer.find_by(email: customer_params[:email])
      if @customer.nil?
        @customer = Customer.new(customer_params)
        unless @customer.save
          @booking = Booking.new(booking_params)
          load_reservation_data
          render :new_reservation, status: :unprocessable_entity
          return
        end
      end

      # Create booking
      @booking = Booking.new(booking_params.except(:room_ids))
      @booking.customer = @customer

      if @booking.save
        # Add selected rooms to booking
        if params[:booking][:room_ids].present?
          params[:booking][:room_ids].reject(&:blank?).each do |room_id|
            room = Room.find(room_id)
            if room.available_for_dates?(@booking.start_date, @booking.finish_date)
              BookingRoom.create!(booking: @booking, room: room)
            end
          end
        end

        redirect_to bookings_path, notice: "Reservation was successfully created."
      else
        load_reservation_data
        render :new_reservation, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    load_reservation_data
    flash.now[:alert] = "There was an error creating the reservation: #{e.message}"
    render :new_reservation, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.expect(booking: [ :customer_id, :start_date, :finish_date, :payment_method, room_ids: [] ])
    end

    def customer_params
      params.expect(customer: [ :email, :full_name, :address, :city ])
    end

    def load_reservation_data
      @room_types = RoomType.all

      # Build rooms query with filters
      @rooms = Room.available.includes(:room_type, :facilities)

      # Filter by room type if specified
      if params[:room_type_id].present?
        @rooms = @rooms.where(room_type_id: params[:room_type_id])
      end

      # Filter by price range if specified
      if params[:min_price].present?
        @rooms = @rooms.where("price >= ?", params[:min_price])
      end

      if params[:max_price].present?
        @rooms = @rooms.where("price <= ?", params[:max_price])
      end

      # Convert to array for date filtering if needed
      rooms_array = @rooms.to_a

      # Filter by availability for specific dates if provided
      if params[:start_date].present? && params[:end_date].present?
        begin
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
          rooms_array = rooms_array.select { |room| room.available_for_dates?(start_date, end_date) }
        rescue Date::Error
          # Invalid date format, ignore date filter
        end
      end

      @rooms = rooms_array
    end
end
