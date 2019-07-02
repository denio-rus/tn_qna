class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, User
    render json: current_resource_owner 
  end

  def index
    authorize! :read, User
    @other_users = User.where.not(id: current_resource_owner.id)
    render json: @other_users
  end
end
