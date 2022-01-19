class SocialAuthController < Devise::SessionsController
  def authenticate_social_auth_user
    @user = User.signin_or_create_from_provider(params) # this method add a user who is new or logins an old one
    if @user.persisted?
      sign_in(@user)
      auth_token = @user.generate_jwt
      render json: {
        status: 'SUCCESS',
        message: "user was successfully logged in through #{params[:provider]}",
        token: auth_token
      },
      status: :created
    else
      render json: {
        status: 'FAILURE',
        message: "There was a problem signing you in through #{params[:provider]}",
        data: @user.errors
      },
      status: :unprocessable_entity
    end
  end  
end