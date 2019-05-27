class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable
    link.destroy if current_user.author_of?(resource)
    if resource.is_a?(Question)
      @question = resource     
    else
      @answer = resource
    end
  end
end