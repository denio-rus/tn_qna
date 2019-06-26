class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable
    authorize! :destroy, link
    link.destroy
    if resource.is_a?(Question)
      @question = resource     
    else
      @answer = resource
    end
  end
end