class SpacesController < ApplicationController

  def index
    @available_spaces = Space.available
    @parking_assignments = ParkingAssignment.active
  end

end
