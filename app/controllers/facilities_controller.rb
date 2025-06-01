class FacilitiesController < ApplicationController
  before_action :set_facility, only: %i[ show edit update destroy ]

  # GET /facilities
  def index
    @q = Facility.ransack(params[:q])
    @pagy, @facilities = pagy(@q.result(distinct: true).order(created_at: :desc))
    @facility_form = Facility.new
  end

  # GET /facilities/1
  def show
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
  end

  # POST /facilities
  def create
    @facility = Facility.new(facility_params)

    if @facility.save
      redirect_to facilities_path, notice: "Facility was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /facilities/1
  def update
    if @facility.update(facility_params)
      redirect_to facilities_path, notice: "Facility was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /facilities/1
  def destroy
    @facility.destroy!
    redirect_to facilities_path, notice: "Facility was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def facility_params
      params.expect(facility: [ :name, :quantity, :section_type ])
    end
end
