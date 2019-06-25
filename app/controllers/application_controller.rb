class ApplicationController < ActionController::Base
  before_action :set_user_id_for_js

  private 

  def set_user_id_for_js
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
  
  check_authorization
end
