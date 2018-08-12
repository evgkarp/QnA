require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js   { head :forbidden }
      format.json { head :forbidden }
      format.html { redirect_to root_path, notice: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
end
