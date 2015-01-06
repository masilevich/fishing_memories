class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :resource_name
  helper_method :resource_label
  helper_method :plural_resource_label

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  
end
