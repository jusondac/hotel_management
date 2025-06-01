class RoomTypesController < ApplicationController
  before_action :set_room_type, only: %i[ show edit update destroy ]

  # GET /room_types
  def index
    @q = RoomType.ransack(params[:q])
    @pagy, @room_types = pagy(@q.result(distinct: true).order(created_at: :desc))
    @room_type_form = RoomType.new
  end

  # GET /room_types/1
  def show
  end

  # GET /room_types/new
  def new
    @room_type = RoomType.new
  end

  # GET /room_types/1/edit
  def edit
  end

  # POST /room_types
  def create
    @room_type = RoomType.new(room_type_params)

    if @room_type.save
      redirect_to room_types_path, notice: "Room type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /room_types/1
  def update
    if @room_type.update(room_type_params)
      redirect_to room_types_path, notice: "Room type was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /room_types/1
  def destroy
    @room_type.destroy!
    redirect_to room_types_path, notice: "Room type was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_type
      @room_type = RoomType.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def room_type_params
      params.expect(room_type: [ :name ])
    end
end
