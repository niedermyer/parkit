class VehiclesController < ApplicationController

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.save!
    flash[:notice] = "The vehicle was successfully created"
    redirect_to vehicle_path(@vehicle)

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "There was a problem saving the vehicle. Check the form for errors"
    render :new
  end

  def show
    @vehicle = Vehicle.find(params[:id])
  end

  def index
    @vehicles = Vehicle.all
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update_attributes!(vehicle_params)

    flash[:notice] = "The vehicle was successfully updated"
    redirect_to vehicle_path(@vehicle)
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "There was a problem updated the record. Check the form for errors"
    render :edit
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy!

    flash[:notice] = "The vehicle was successfully destroyed"
    redirect_to vehicles_path
  rescue ActiveRecord::RecordNotDestroyed
    flash[:alert] = "The record could not be destroyed"
    redirect_to vehicle_path(@vehicle)
  rescue ActiveRecord::DeleteRestrictionError
    flash[:alert] = "The record could not be destroyed since it is associated with a Parking Assignment"
    redirect_to vehicle_path(@vehicle)
  end

  private

  def vehicle_params
    params.require(:vehicle).permit([:license_state,
                                     :license_number,
                                     :description,
                                     :contact_name,
                                     :contact_phone
                                    ])
  end
end
