class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    resource = attachment.record
    authorize! :destroy, attachment
    attachment.purge# if current_user.author_of?(resource)
    if resource.is_a?(Question)
      @question = resource     
    else
      @answer = resource
    end
  end
end