class User < ActiveRecord::Base
  ACCEPTABLE_EMAILS = %w(codequest.com codequest.eu)

  devise :database_authenticatable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(params)
    user = find_by(params.slice(:provider, :uid))
    if user.nil? && params.info.email.split('@')[1].in?(ACCEPTABLE_EMAILS)
      user = User.new({
                          provider: params.provider,
                          uid: params.uid,
                          name: params.info.name,
                          email: params.info.email
                      })
      user.save!
    end
    user
  end
end
