class RoomFacilitiesController < ApplicationController
  before_action :set_room_facility, only: %i[ show edit update destroy ]

  # GET /room_facilities
  def index
    @q = RoomFacility.ransack(params[:q])
    @pagy, @room_facilities = pagy(@q.result(distinct: true).order(created_at: :desc))
    @room_facility_form = RoomFacility.new
  end

  # GET /room_facilities/1
  def show
  end

  # GET /room_facilities/new
  def new
    @room_facility = RoomFacility.new
  end

  # GET /room_facilities/1/edit
  def edit
  end

  # POST /room_facilities
  def create
    @room_facility = RoomFacility.new(room_facility_params)

    if @room_facility.save
      redirect_to room_facilities_path, notice: "Room facility was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /room_facilities/1
  def update
    if @room_facility.update(room_facility_params)
      redirect_to room_facilities_path, notice: "Room facility was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /room_facilities/1
  def destroy
    @room_facility.destroy!
    redirect_to room_facilities_path, notice: "Room facility was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_facility
      @room_facility = RoomFacility.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def room_facility_params
      params.expect(room_facility: [ :facility_id, :room_id ])
    end
end
