class UserNotifier < ActionMailer::Base
  default from: 'no-reply@codequest-manager.herokuapp.com'

  def debt_notification(user)
    # @user = user
    # mail( :to => @user.email,
    #       :subject => 'Thanks for signing up for our amazing app' )
  end
end
