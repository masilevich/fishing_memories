require "resource"
require "flash_to_header"

class ApplicationController < ActionController::Base

  include FlashToHeader

  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :flash_to_headers

  helper_method :find_resource

  def after_sign_in_path_for(resource)
    memories_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def find_nested  
    params.each do |name, value|  
      if name =~ /(.+)_id$/  
        return $1.classify.constantize.find(value)  
      end  
    end  
    nil  
  end  

  def find_resource
    if params[:id]
      @resource = resource_class.find(params[:id])
    else
      find_nested
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  
end
