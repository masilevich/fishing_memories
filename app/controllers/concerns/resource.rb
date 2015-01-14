module Resource

  extend ActiveSupport::Concern

  included do
    layout :resource_layout
    helper_method :resource_class, :resource_label, :plural_resource_label, 
      :find_resource, :plural_resource_name, :singular_resource_name
    helper_method :resources_path, :resource_path, :new_resource_path, :edit_resource_path
    before_action :find_resource, only: [:edit, :update, :show]
  end

  def new
    @resource = resources.build()
  end

  def create
    @resource = resources.build(resource_params)
    if @resource.save
      flash[:notice] = t('fishing_memories.model_created', model: resource_label)
      redirect_to resources_path
    else
      flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
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
      render 'edit'
    end
  end

  def index 
    @resources = resources.page(params[:page])
  end

  def destroy
    delete_result = find_resource.destroy
    success_flash = t('fishing_memories.model_destroyed', model: resource_label)
    fail_flash = t('fishing_memories.model_not_destroyed', model: resource_label)
    @resources = resources.page(params[:page]) if delete_result
    respond_to do |format|
      format.html do
        if delete_result
          flash[:notice] = success_flash
          redirect_to resources_path
        else
          flash[:alert] = fail_flash
        end
      end
      format.js do
      if delete_result
        flash[:notice] = success_flash
      else
        flash[:alert] = fail_flash
      end
      end
    end
  end

  def show
  end

  private

  def resource_class
    controller_name.classify.constantize
  end

  def resource_name
    resource_class.model_name.name
  end

  def singular_resource_name
    resource_class.model_name.singular
  end

  def plural_resource_name
    resource_class.model_name.plural
  end

  def resource_label(resource_class = resource_class)
    resource_class.model_name.human count: 1,
    default: resource_class.to_s.gsub('::', ' ').titleize
  end

  def plural_resource_label(resource_class = resource_class, options = {})
    defaults = {count: PLURAL_MANY_COUNT, default: resource_label.pluralize.titleize}
    resource_class.model_name.human defaults.merge options
  end

  def find_resource
    if params[:id]
      @resource = resource_class.find(params[:id])
    end
  end

  def resource_params
    send "#{singular_resource_name}_params"
  end

  def resource_path(resource)
    polymorphic_path(resource)
  end

  def new_resource_path
    new_polymorphic_path(resource_class)
  end

  def edit_resource_path(resource)
    edit_polymorphic_path(resource)
  end

  def resources_path
    polymorphic_path(plural_resource_name)
  end


  private

  def resource_layout
    case action_name
    when 'index', 'show', 'new', 'edit'
      "resources/#{action_name}"
    end
  end

  def resources
    current_user.send(plural_resource_name)
  end
end