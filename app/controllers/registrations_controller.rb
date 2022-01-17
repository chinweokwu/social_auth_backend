class RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(user_params)

    if user.save
      token = user.generate_jwt
      render json: { user: UserSerializer.new(user), token: token}, status: :created
    else
      render json: { errors: { 'registration' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
