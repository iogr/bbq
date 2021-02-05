class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  # Девайзовский фильтр, который посылает незалогинившихся юзеров
  # Просматривать профили могут и анонимы
  before_action :authenticate_user!, except: [:show]

  # Задаем объект @user для шаблонов и экшенов
  before_action :set_current_user, except: [:show]

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end
  # Пропишем, что разрешено передавать в params
  def user_params
    params.require(:user).permit(:name, :email)
  end

  def unlock
    user = User.find(params[:id])
    user.unlock_access!
    redirect_to users_path
  end
end
