class MemoriesController < ApplicationController

	include Resource

	def new
		@memory = memories.build()
	end

	def create
		@memory = memories.build(memory_params)
		if @memory.save
			flash[:notice] = 'Запись добавлена'
			redirect_to memories_path
		else
			flash.now[:alert] = 'Запись не добавлена'
			render 'new'
		end
	end

	def index
	end

	private

	def memories
		current_user.memories
	end

		def memory_params
		params.require(:memory).permit(:occured_at, :description)
	end
end
