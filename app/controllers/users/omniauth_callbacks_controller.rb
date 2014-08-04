class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Google')
    else
      redirect_to users_dashboard_path, alert: 'You must have an email at code quest'
    end
  end
end