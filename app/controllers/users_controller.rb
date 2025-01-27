class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]



  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user), notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to user_path(user), notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end

  def require_signin
    unless current_user
      redirect_to signin_url, alert: 'You must be signed in to access this page.'
    end
  end

  def require_correct_user
    user = User.find(params[:id])
    unless current_user == user
      redirect_to root_url
    end
  end
end
