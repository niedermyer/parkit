class DashboardController < ApplicationController

  def show
    @available_spaces = Space.available
    @parking_assignments = ParkingAssignment.active
  end

end
