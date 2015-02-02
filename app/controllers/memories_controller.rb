class MemoriesController < ApplicationController

	include Resource

  load_and_authorize_resource

  before_action :set_tackles, only: [:new, :edit]
  before_action :set_tackle_sets, only: [:new, :edit]
  before_action :set_ponds, only: [:new, :edit]

  def index
    @q = resources.ransack(params[:q])
    @resources = @q.result
    @resources = if sort_column == 'description'
      @resources.sort_by_description(sort_direction)
    else
      sort_column ? @resources.reorder(sort_column + ' ' + sort_direction) : @resources 
    end

    unless @resources.kind_of?(Array)
      @resources = @resources.page(params[:page])
    else
      @resources = Kaminari.paginate_array(@resources).page(params[:page])
    end
    
  end

  def create
    @resource = resources.build(resource_params)
    if @resource.save
      flash[:notice] = t('fishing_memories.model_created', model: resource_label)
      redirect_to resources_path
    else
      flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
      set_ponds
      set_tackles
      set_tackle_sets
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
      set_ponds
      set_tackles
      set_tackle_sets
      render 'edit'
    end
  end

  private

  def memory_params
    params.require(:memory).permit(:occured_at, :description, 
      tackle_ids: [], pond_ids: [], tackle_set_ids: [])
  end

  def set_tackles
    @tackles = current_user.tackles
  end

  def set_tackle_sets
    @tackle_sets = current_user.tackle_sets
  end

  def set_ponds
    @ponds = current_user.ponds
  end
end
