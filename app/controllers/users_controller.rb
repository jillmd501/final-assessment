class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to @user #assumes you want to see the show page
      else
        flash.now[:error] = "Please enter valid info"
        render :new
      end
  end

  def show
  end

private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
