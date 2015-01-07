module Resource

  extend ActiveSupport::Concern

  included do
    layout :resource_layout
    helper_method :resource_name, :resource_label, :plural_resource_label, :find_resource
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

  private

  def resource_layout
    case action_name
    when 'index', 'show', 'new', 'edit'
      "resources/#{action_name}"
    end
  end
end