class VehiclesController < ApplicationController

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.save!
    flash[:notice] = "The vehicle was successfully saved"
    redirect_to vehicle_path(@vehicle)

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "There was a problem saving the vehicle. Check the form for errors"
    render :new
  end

  def show
    @vehicle = Vehicle.find(params[:id])
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
