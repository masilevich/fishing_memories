class MemoriesController < ApplicationController

	include Resource

	def new
		@memory = memories.build()
	end

	def create
		@memory = memories.build(memory_params)
		if @memory.save
			flash[:notice] = t('fishing_memories.model_created', model: resource_label)
			redirect_to memories_path
		else
			flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
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
