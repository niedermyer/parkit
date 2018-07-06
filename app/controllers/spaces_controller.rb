class SpacesController < ApplicationController

  def index
    @spaces = Space.available
  end

end
