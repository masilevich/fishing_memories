require "resource"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  after_filter :flash_to_headers

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    flash.discard # don't want the flash to appear when you reload page
  end

  private

  def flash_message
    [:error, :warning, :notice, :alert].each do |type|
      return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    [:error, :warning, :notice, :alert].each do |type|
      return type unless flash[type].blank?
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  
end
