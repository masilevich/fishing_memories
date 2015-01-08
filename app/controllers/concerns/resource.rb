module Resource

  extend ActiveSupport::Concern

  included do
    layout :resource_layout
    helper_method :resource_class, :resource_label, :plural_resource_label, 
      :find_resource, :plural_resource_name, :singular_resource_name
  end

  def new
    @resource = resources.build()
  end

  def create
    @resource = resources.build(send("#{singular_resource_name}_params"))
    if @resource.save
      flash[:notice] = t('fishing_memories.model_created', model: resource_label)
      redirect_to polymorphic_path(plural_resource_name)
    else
      flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
      render 'new'
    end
  end

  def index 
    @resources = resources
  end

  def destroy
    delete_result = find_resource.destroy
    respond_to do |format|
      format.html do
        if delete_result
          flash[:notice] = t('fishing_memories.model_destroyed', model: resource_label)
          redirect_to polymorphic_path(plural_resource_name)
        else
          flash[:alert] = t('fishing_memories.model_destroyed', model: resource_label)
        end
      end
      format.js
    end
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

  def resource_label
    resource_class.model_name.human count: 1,
    default: resource_class.to_s.gsub('::', ' ').titleize
  end

  def plural_resource_label(options = {})
    defaults = {count: 2.1, default: resource_label.pluralize.titleize}
    resource_class.model_name.human defaults.merge options
  end

  def find_resource
    if params[:id]
      @resource = resource_class.find(params[:id])
    end
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