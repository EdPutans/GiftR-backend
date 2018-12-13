class Api::V1::UsersController < ApplicationController


  def index
      @users = User.all
      render json: @users
  end


  def create
      @user = User.new(user_params)
      if @user.save
          render json: @user
      else
          render json: {error: "Unable to create this user"}, status: 400
      end
  end

  def show
      @user = User.find_by(id: params[:id])
      if @user
          render json: @user
      else
          render json: {error: "User was not found"}, status: 404
      end
  end

  def update
      @user = User.find(params[:id])
      if @user.update(user_params)
          @user.save
          render json: @user
      else
          render json: {error: "Unable to find this user"}, status: 400
      end
  end

  def destroy
    @user = Gift.find_by(id: params[:id])
    @user.delete
    render json: User.all
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_digest, :age, :img_url)
      # password_digest or stretch with JWT
  end

end
