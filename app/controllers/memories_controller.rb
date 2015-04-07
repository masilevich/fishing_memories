class MemoriesController < ApplicationController

	include Resource

  load_and_authorize_resource

  before_action :set_resources
  before_action :set_grouped_tackles_options, only: [:new, :edit, :index]
  before_action :set_grouped_tackle_sets_options, only: [:new, :edit, :index]
  before_action :set_grouped_ponds_options, only: [:index, :new, :edit]
  before_action :set_grouped_places_options, only: [:index, :new, :edit]

  def create
    @resource = resources.build(resource_params)
    if @resource.save
      flash[:notice] = t('fishing_memories.model_created', model: resource_label)
      redirect_to resources_path
    else
      flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
      set_grouped_ponds_options
      set_grouped_places_options
      set_grouped_tackles_options
      set_grouped_tackle_sets_options
      render 'new'
    end
  end

  def edit
  end

  def update
    if @resource.update_attributes(resource_params)
      flash[:notice] = t('fishing_memories.model_updated', model: resource_label)
      redirect_to resources_path
    else
      flash.now[:alert] = t('fishing_memories.model_not_updated', model: resource_label)
      set_grouped_ponds_options
      set_grouped_places_options
      set_grouped_tackles_options
      set_grouped_tackle_sets_options
      render 'edit'
    end
  end

  private

  def memory_params
    params.require(:memory).permit(:occured_at, :weather, :description, 
      :conclusion, :pond_state, tackle_ids: [], pond_ids: [], place_ids: [],
      tackle_set_ids: [])
  end

  def set_grouped_tackles_options
    @tackles_options = current_user.tackles.grouped_by_category_options_for_select(current_user.tackle_categories, :name)
  end

  def set_grouped_tackle_sets_options
    @tackle_sets_options = current_user.tackle_sets.grouped_by_category_options_for_select(current_user.tackle_set_categories, :title)
  end

  def set_grouped_ponds_options
    @ponds_options = current_user.ponds.grouped_by_category_options_for_select(current_user.pond_categories, :name)
  end

  def set_grouped_places_options
    @places_options = current_user.places.grouped_options_for_select(current_user.ponds)
  end

  def set_resources
    @resources = resources.includes(:tackles, :tackle_sets, :ponds, :places)
  end

end
