class UsersController < ApplicationController
    # POST /bookmarks
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @bookmark
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:authentication_token, :username)
    end
end
