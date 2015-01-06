module Resource

  extend ActiveSupport::Concern

  included do
    before_filter :generate_default_action_items
    before_filter :resource_title
  end

  private

  def resource_name
    controller_name.classify.constantize
  end

  def resource_label
    resource_name.model_name.human count: 1,
    default: resource_name.to_s.gsub('::', ' ').titleize
  end

  def plural_resource_label(options = {})
    defaults = {count: 2.1, default: resource_label.pluralize.titleize}
    resource_name.model_name.human defaults.merge options
  end

  def find_resource
    if params[:id]
      @resource = resource_name.find(params[:id])
    end
  end

  def resource_title
    case action_name
    when "new", "edit", "destroy"
      @resource_title = I18n.t("fishing_memories.#{action_name}_model", model: resource_label)
    when "index"
      @resource_title = plural_resource_label
    end
  end

  def generate_default_action_items

    new_link = view_context.link_to I18n.t('fishing_memories.new_model', 
      model: resource_label),   view_context.new_polymorphic_path(resource_name)
    if find_resource
      edit_link = view_context.link_to I18n.t('fishing_memories.edit_model', 
        model: resource_label),   view_context.edit_polymorphic_path(@resource)
      destroy_link = view_context.link_to I18n.t('fishing_memories.delete_model', 
        model: resource_label),   view_context.polymorphic_path(@resource), method: :delete,
      data: {confirm: I18n.t('fishing_memories.delete_confirmation')}
    end
    @action_items = []
    case action_name
    when "show"
      @action_items << edit_link
      @action_items << destroy_link
    when "index"
      @action_items << new_link
    end   
  end
end