class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(omniauth_params)
    if @user
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Google')
    else
      redirect_to root_path, alert: 'You must have an email at code quest'
    end
  end

  private

  def omniauth_params
    request.env['omniauth.auth']
  end
end