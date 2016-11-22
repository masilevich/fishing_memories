class CalendarsController < ApplicationController

  def show
  	@memories = current_user.memories
  end
end
