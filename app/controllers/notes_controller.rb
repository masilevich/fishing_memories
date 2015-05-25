class NotesController < ApplicationController

	include Resource

	before_action :set_tags, only: [:index]
	
	load_and_authorize_resource

	def autocomplete_tags
    @tags = ActsAsTaggableOn::Tag.
      where("name LIKE ?", "#{params[:q]}%").
      order(:name)
    respond_to do |format|
      format.json { render json: @tags , :only => [:id, :name] }
    end
  end

	private

	def note_params
		params.require(:note).permit(:name, :text, :tag_list)
	end

	def set_tags
		@tags = current_user.notes.tag_counts_on(:tags)
	end
end
