class ApplicationController < ActionController::Base
  before_action :set_user_id_for_js

  check_authorization unless: :devise_controller?

  private 

  def set_user_id_for_js
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { head :forbidden }
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end
end
