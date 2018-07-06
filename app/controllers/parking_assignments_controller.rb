class ParkingAssignmentsController < ApplicationController

  def new
    space = Space.find(params[:space_id])
    @parking_assignment = ParkingAssignment.new(space: space)
    @vehicles = Vehicle.all
  end

  def create
    @parking_assignment = ParkingAssignment.new(parking_assignment_params.merge(started_at: Time.zone.now))
    @parking_assignment.save!
    flash[:notice] = "The parking assignment was successfully created"
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid => e
    if space_has_already_been_taken?(e)
      flash[:alert] = "The parking assignment could not be created because the space is no longer be available"
      redirect_to root_path
    else
      flash[:alert] = "There was a problem with creating the parking assignment"
      render :new
    end
  end

  def show
    @parking_assignment = ParkingAssignment.find(params[:id])
  end

  def archive
    parking_assignment = ParkingAssignment.active.find(params[:parking_assignment_id])
    parking_assignment.ended_at = Time.zone.now
    parking_assignment.save!
    flash[:notice] = "The parking assignment was successfully archived"
    redirect_to root_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "There was a problem archiving the parking assignment. Ensure that the vehicle was not already checked out"
    redirect_to root_path
  end

  private

  def parking_assignment_params
    params.require(:parking_assignment).permit([:space_id, :vehicle_id])
  end

  def space_has_already_been_taken?(e)
    errors = e.record.errors
    errors.keys.include?(:space) && errors.messages[:space].include?('has already been taken')
  end
end
