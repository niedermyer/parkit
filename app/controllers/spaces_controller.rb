class SpacesController < ApplicationController

  def index
    @available_spaces = Space.available
    @assigned_spaces = Space.unavailable
  end

end
