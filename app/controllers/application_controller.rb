class ApplicationController < ActionController::Base
  before_action :set_user_id_for_js

  private 

  def set_user_id_for_js
    gon.user_id = current_user.id if current_user
  end
end
