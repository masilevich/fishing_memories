require 'resource/actions'
require 'resource/naming'
require 'resource/view_helpers'

module Resource

  include Actions
  include Naming
  include ViewHelpers
  include Sort

  extend ActiveSupport::Concern

  included do
    layout :resource_layout

    helper_method :resource_class, :resource_label, :plural_resource_label, 
      :plural_resource_name, :singular_resource_name
    helper_method :resources_path, :resource_path, :new_resource_path, :edit_resource_path
    helper_method :sort_column, :sort_direction
    before_action :find_resource, only: [:edit, :update, :show]
  end

  private

  def resource_params
    send "#{singular_resource_name}_params"
  end

  def resource_layout
    case action_name
    when 'index', 'show', 'new', 'edit'
      "resources/#{action_name}"
    end
  end

  def resources
    if resource_class.method_defined? :category
      current_user.send(plural_resource_name).includes(:category)
    else
      current_user.send(plural_resource_name)
    end
  end

end