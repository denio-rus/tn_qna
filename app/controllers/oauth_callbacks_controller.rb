class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    
    if @user&.persisted?
      sign_in_existed_user(@user) 
    else 
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted? && @user.email != 'no_email_given@site.om'
      sign_in_existed_user(@user) 
    elsif @user&.persisted? && @user.email == 'no_email_given@site.om'
      request_email
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def sign_in_existed_user(user)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
  end

  def request_email
    flash.now[:notice] = 'We need email to continue, please, enter your email for registration'
    render 'devise/registrations/ask_email_for_oauth'
  end
end
