class NotesController < ApplicationController

	include Resource
	
	load_and_authorize_resource

	private

	def note_params
		params.require(:note).permit(:name, :text)
	end
end
