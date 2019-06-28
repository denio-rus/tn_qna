# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  # PATCH /users/:id/ask_email_for_oauth
  def ask_email_for_oauth
    @user = User.find(params[:id])
    @user.email = params[:user][:email]
    if @user.save
      @user.send_confirmation_instructions
      redirect_to root_path, notice: 'Letter was send to given email for confirmation'
    else
      render :ask_email_for_oauth
    end
  end
end
