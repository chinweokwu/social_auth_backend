class User < ApplicationRecord
  include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]
  
  def generate_jwt
    JWT.encode({id: id, exp: 60.days.from_now.to_i}, 'yourSecret')
  end

  def self.signin_or_create_from_provider(provider_data)
    where(provider: provider_data[:provider], uid: provider_data[:uid]).first_or_create do |user|
      user.email = provider_data[:info][:email]
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation! # when you signup a new user, you can decide to skip confirmation
    end
  end
end
