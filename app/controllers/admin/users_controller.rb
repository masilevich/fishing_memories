	class Admin::UsersController < Admin::AdminController

		include Resource

		before_action :set_resources, only: [:index]

		private
		
		def set_resources
	    @resources = User.all
	  end

	  def user_params
			params.require(:user).permit(:role)
		end

	end
